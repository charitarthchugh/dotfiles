{
  description = "Humara Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust-overlay — needed by the codex build glue in `outputs` below
    # (upstream's flake builds codex-rs against rust-bin.stable.latest.minimal).
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hermes — official upstream flake (NousResearch/hermes-agent). Not
    # version-pinned: follows upstream and is bumped manually with
    #   nix flake lock --update-input hermes
    # (run it right after a release publishes to land on the release commit —
    # flakes have no "latest release" ref, so an unpinned input tracks the
    # default branch). packages.default = "full" (uv2nix build with the
    # portable optional integrations pre-built: anthropic, bedrock, messaging,
    # matrix, voice, ...). Builds from source; no binary cache.
    hermes = {
      url = "github:NousResearch/hermes-agent";
    };
    # codex — official upstream flake (openai/codex). Not version-pinned;
    # bump manually with
    #   nix flake lock --update-input codex
    # Builds codex-rs from source via rust-overlay; no binary cache.
    codex = {
      url = "github:openai/codex";
    };
    # herdr — official upstream flake (repo moved from ogulcancelik/herdr to
    # herdrdev/herdr). Pinned to a release tag per releases-only preference;
    # builds from source (vendored crates, no binary cache). Bump via:
    #   nix flake lock --update-input herdr
    herdr = {
      url = "github:herdrdev/herdr/v0.9.5";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };

      # codex — built from the upstream flake's own build file (openai/codex
      # codex-rs/default.nix), invoked exactly the way inputs.codex's flake
      # invokes it. The published flake currently fails to *evaluate*: its
      # hard-coded cargoLock.outputHashes list is missing the
      # appcontainer_common-0.8.0 git dependency (git+github:microsoft/mxc),
      # and importCargoLock throws at eval time — not fixable via overrides
      # (recurring regression pattern: openai/codex#7759, #7863, #11185).
      # This wrapper injects the missing hash by wrapping buildRustPackage;
      # it is harmless once upstream fixes default.nix (their list wins for
      # keys it has). If the mxc rev changes upstream before they fix it, the
      # FOD error prints the new expected hash — update it in extraGitHashes.
      codexUpstream =
        let
          # upstream's flake reads the version from the workspace Cargo.toml;
          # main keeps a "0.0.0" placeholder and falls back to a dev version.
          cargoToml = builtins.fromTOML (builtins.readFile "${inputs.codex}/codex-rs/Cargo.toml");
          version =
            if cargoToml.workspace.package.version != "0.0.0" then
              cargoToml.workspace.package.version
            else
              "0.0.0-dev+${inputs.codex.shortRev or "dirty"}";
          # One key per Cargo.lock git dependency (name-version); crates
          # sharing a repo share the narHash. We compute ALL of them (via
          # builtins.fetchGit narHash at the rev pinned in Cargo.lock) and
          # merge ON TOP of upstream's list — their hard-coded entries go
          # stale (crossterm, tokio-tungstenite and tungstenite were all
          # wrong at codex 7b44ac1). If a rev moves before upstream fixes
          # default.nix, the FOD error prints the new expected hash.
          extraGitHashes = {
            # https://github.com/microsoft/mxc @ 6cd3d58f05d3447e67109cfb75e042803b843ca4
            "appcontainer_common-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "learning_mode_core-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "learning_mode_windows-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "mxc_config_contract-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "mxc_telemetry-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "process_security_environment_spec-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "sandbox_spec-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            "wxc_common-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
            # https://github.com/openai-oss-forks/crossterm @ ed1cdab335221515706178d68495bba2aed1924f
            "crossterm-0.29.0" = "sha256-7ZzFZ6c6uU27ZxCGOPK82Aia4CzTnJwksAfbpTMPikY=";
            # https://github.com/hyperium/h3 @ e07e69412876f7e26f026bd75a48b2704d8c8283
            "h3-0.0.8" = "sha256-fgE0AMj5d4iattTC/yQwnACV8uEu+KR7wD29xfEm8M0=";
            "h3-quinn-0.0.10" = "sha256-fgE0AMj5d4iattTC/yQwnACV8uEu+KR7wD29xfEm8M0=";
            # https://github.com/helix-editor/nucleo @ 4253de9faabb4e5c6d81d946a5e35a90f87347ee
            "nucleo-0.5.0" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
            "nucleo-matcher-0.3.1" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
            # https://github.com/dzbarsky/rules_rust @ b56cbaa8465e74127f1ea216f813cd377295ad81
            "runfiles-0.1.0" = "sha256-uJpVLcQh8wWZA3GPv9D8Nt43EOirajfDJ7eq/FB+tek=";
            # https://github.com/modelcontextprotocol/rust-sdk @ 98a54789b80110ad210495c4ad845c89e1980471
            "rmcp-3.5.1" = "sha256-yczrrD6SnXhblos5oU6fbyDc7vkRah9DsF41hcaKzi4=";
            "rmcp-macros-3.5.1" = "sha256-yczrrD6SnXhblos5oU6fbyDc7vkRah9DsF41hcaKzi4=";
            # https://github.com/openai-oss-forks/tokio-tungstenite @ 0e5b2d73aa18dd9f0a50ee9ff199d5aef7594186
            "tokio-tungstenite-0.28.0" = "sha256-V1xmnrfRWOcZZogelZEA4vvyMj2awCfHVA5/glQ6KAI=";
            # https://github.com/openai-oss-forks/tungstenite-rs @ 4fffad30fe373adbdcffab9545e9e9bf4f2fc19f
            "tungstenite-0.27.0" = "sha256-VVHhk7l9J/sEmG3q/UuV/sQ3f+fGsmq5vumSy8vbMvw=";
          };
          # rusty_v8 (v8 crate 152.2.0 in the locked Cargo.lock): codex
          # enables the ptrcomp+sandbox features, whose prebuilt artifacts
          # openai publishes on THEIR repo's releases (rusty-v8-vX tag), not
          # on denoland/rusty_v8. Build is network-blocked, so fetch both
          # artifacts here and hand them to the v8 build script via
          # RUSTY_V8_ARCHIVE / RUSTY_V8_SRC_BINDING_PATH (same approach as
          # numtide's llm-agents codex). Update version + both hashes
          # together whenever the locked v8 version changes after a bump.
          rustyV8Version = "152.2.0";
          rustyV8BaseUrl = "https://github.com/openai/codex/releases/download/rusty-v8-v${rustyV8Version}";
          librusty_v8 = pkgs.fetchurl {
            name = "librusty_v8-${rustyV8Version}";
            url = "${rustyV8BaseUrl}/librusty_v8_ptrcomp_sandbox_release_x86_64-unknown-linux-gnu.a.gz";
            hash = "sha256-s7SQ8qqAntp/ascn+FH7AM6DVb5ygnV3z6rCjHE3280=";
          };
          rustyV8SrcBinding = pkgs.fetchurl {
            name = "src_binding-${rustyV8Version}.rs";
            url = "${rustyV8BaseUrl}/src_binding_ptrcomp_sandbox_release_x86_64-unknown-linux-gnu.rs";
            hash = "sha256-Pk1f7Nvg+YpgF+adfKglGad/sDLF615M2+zdPi7FGdU=";
          };
          baseRustPlatform = pkgs.makeRustPlatform {
            cargo = pkgs.rust-bin.stable.latest.minimal;
            rustc = pkgs.rust-bin.stable.latest.minimal;
          };
          # default.nix hard-codes cargoLock.outputHashes internally, so
          # merge our extra hashes at call time via this wrapper.
          rustPlatform = baseRustPlatform // {
            buildRustPackage =
              f:
              baseRustPlatform.buildRustPackage (
                final:
                let
                  attrs = f final;
                  lock = attrs.cargoLock or { };
                in
                attrs
                // {
                  cargoLock = lock // {
                    outputHashes = (lock.outputHashes or { }) // extraGitHashes;
                  };
                }
              );
          };
        in
        (pkgs.callPackage "${inputs.codex}/codex-rs" {
          inherit version rustPlatform;
        }).overrideAttrs
          (
            final: prev: {
              # Build only the CLI + code-mode host (same package selection as
              # numtide's llm-agents build). Building the full workspace drags in
              # the voice-host member → gstreamer-sys (needs gstreamer >= 1.28;
              # nixpkgs 26.05 only has 1.26.11), alsa, dbus, glib — none of which
              # upstream's default.nix provides anyway. Revisit if voice lands as
              # a separate feature/binary upstream or if 26.05 gets gst 1.28.
              cargoBuildFlags = [
                "--package"
                "codex-cli"
                "--package"
                "codex-code-mode-host"
              ];
              cargoInstallFlags = [
                "--package"
                "codex-cli"
                "--package"
                "codex-code-mode-host"
              ];
              env = (prev.env or { }) // {
                RUSTY_V8_ARCHIVE = librusty_v8;
                RUSTY_V8_SRC_BINDING_PATH = rustyV8SrcBinding;
              };
            }
          );
    in
    {
      # convenience outputs so each agent package can be built standalone
      # (faster iteration than the full home-manager generation):
      #   nix build .#codex   /   nix build .#hermes
      packages.${system} = {
        codex = codexUpstream;
        hermes = inputs.hermes.packages.${system}.default;
      };

      homeConfigurations.humara = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs codexUpstream; };

        modules = [
          ./home.nix
        ];
      };
    };
}
