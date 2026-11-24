{
  description = "Home Manager configuration for the machines without NixOS";

  inputs = {
    # Unstable, the same branch as nixos-config, so the dev tools shared with
    # the NixOS hosts (dev-tools.nix) are the same versions on every machine.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hermes-agent (home.nix) via numtide/llm-agents.nix: a cache-backed,
    # patched build. The old NousResearch/hermes-agent and herdr inputs were
    # dropped; herdr ships as a local mkDerivation in home.nix.
    # NOTE: intentionally NOT following our nixpkgs — numtide builds/publishes
    # against their own pinned nixpkgs, so the cache only hits that way.
    # Bump via:
    #   nix flake update llm-agents
    #
    # On a machine without NixOS, add the cache to /etc/nix/nix.conf, or
    # hermes builds from source:
    #   extra-substituters = https://cache.numtide.com
    #   extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    # skillshare (in dev-tools.nix). Not in nixpkgs; upstream's flake.
    skillshare = {
      url = "github:runkids/skillshare";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Apply with --impure, which lets the configuration read the user, home
  # directory and system of whoever runs it:
  #   home-manager switch --impure --flake ~/dotfiles/config/home-manager#desktop
  # The first time, before home-manager is installed:
  #   nix run home-manager -- switch --impure --flake ~/dotfiles/config/home-manager#desktop
  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      impureHint = "run home-manager (or nix) with --impure, so the configuration can read the current user.";
      env =
        name:
        let
          value = builtins.getEnv name;
        in
        if value == "" then throw "\$${name} is empty: ${impureHint}" else value;

      # common.nix (the shared dev tools) plus `modules`, for the current user.
      mkHome =
        {
          # The Home Manager release of the configuration's first switch.
          # Never bump it: that changes defaults under existing machines.
          stateVersion ? "26.11",
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = builtins.currentSystem or (throw "builtins.currentSystem is unset: ${impureHint}");
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./common.nix
            {
              home = {
                inherit stateVersion;
                username = env "USER";
                homeDirectory = env "HOME";
              };
            }
          ]
          ++ modules;
        };
    in
    {
      homeConfigurations = {
        # The shared dev tools only: servers and other machines without a desktop.
        default = mkHome { };
        # Plus the desktop apps and what they need (desktop.nix).
        desktop = mkHome { modules = [ ./desktop.nix ]; };
        # The machine that used this flake first: desktop plus its own
        # packages (home.nix).
        humara = mkHome {
          stateVersion = "25.11";
          modules = [
            ./desktop.nix
            ./home.nix
          ];
        };
      };
    };
}
