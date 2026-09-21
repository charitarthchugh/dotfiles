{
  description = "Humara Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hermes-agent was pinned here at github:NousResearch/hermes-agent/v2026.8.19
    # (releases-only preference) but was unused; as of 2026-08-25 hermes is
    # provided via numtide/llm-agents.nix instead (see llm-agents input below),
    # which ships a cache-backed, patched build of the same v2026.8.19 tag.
    #
    # (the old herdr flake input was also dropped here — unused; herdr ships
    # as a local mkDerivation in home.nix)
    #
    # LLM agent packages via numtide/llm-agents.nix (codex, hermes-agent, ...).
    # The official openai/codex flake is broken (openai/codex#3453: source
    # builds hit crates.io FOD hash mismatches / DNS failures); numtide's
    # packages vendor all crates from GitHub release assets (offline cargo
    # build, no crates.io) and are backed by their cache, configured in the
    # host's NixOS nix.settings.
    # NOTE: intentionally NOT following our nixpkgs — numtide builds/publishes
    # against nixpkgs-unstable (pinned in flake.lock), so the cache can hit.
    # No release tags on their repo; versions are bumped declaratively by
    # their updater. Bump via:
    #   nix flake lock --update-input llm-agents
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.humara = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };

        modules = [
          ./home.nix
        ];
      };
    };
}
