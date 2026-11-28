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

    # herdr, herdr-core and herdr-app (dev-tools.nix) and hermes-agent
    # (common.nix) via numtide/llm-agents.nix: cache-backed, patched builds.
    # NOTE: intentionally NOT following our nixpkgs — numtide builds/publishes
    # against their own pinned nixpkgs, so the cache only hits that way.
    # Bump via:
    #   nix flake update llm-agents
    #
    # On a machine without NixOS, add the cache to /etc/nix/nix.conf, or
    # these build from source:
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
        # Same modules as `desktop`; only the stateVersion of this machine's
        # first switch differs. There are no machine-specific packages.
        humara = mkHome {
          stateVersion = "25.11";
          modules = [ ./desktop.nix ];
        };
      };

      # Smoke test of what the nixos-config hosts get from this repo: a NixOS
      # VM booted with the shared dev tools (dev-tools.nix `programs`)
      # installed through the Home Manager NixOS module, then checked from
      # inside a real fish login. CI runs it (see .github/workflows) with the
      # installer action's KVM setup:
      #   nix build .#checks.x86_64-linux.vm
      checks.x86_64-linux.vm =
        let
          system = "x86_64-linux";
        in
        (import "${nixpkgs}/nixos/lib/testing-python.nix" { inherit system; }).runTest {
          name = "dotfiles-dev-tools";
          nodes.machine =
            { ... }:
            {
              imports = [ inputs.home-manager.nixosModules.home-manager ];
              users.users.alice = {
                isNormalUser = true;
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.alice =
                  { pkgs, ... }:
                  {
                    home.stateVersion = "26.11";
                    home.packages = (import ./dev-tools.nix { inherit pkgs inputs; }).programs;
                  };
              };
              virtualisation.memorySize = 2048;
            };
          testScript = ''
            machine.start()
            machine.wait_for_unit("multi-user.target")
            machine.succeed("su - alice -c \"fish -c 'starship --version' | head -1\"")
            machine.succeed("su - alice -c \"nvim --version | head -1\"")
          '';
        };
    };
}
