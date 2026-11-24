# The packages of the machine that used this flake first
# (homeConfigurations.humara). The dev tools that every machine gets (fish,
# neovim, nodejs, poetry, fd, claude-code, codex, ...) come from dev-tools.nix
# through common.nix, shared with the NixOS hosts. Do not list one of them
# here too: when the two builds differ, the build fails with a collision.
{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  llmPkgs = inputs.llm-agents.packages.${system};

  herdr = pkgs.stdenvNoCC.mkDerivation {
    pname = "herdr";
    version = "0.7.1";
    src = pkgs.fetchurl {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v0.7.1/herdr-linux-x86_64";
      hash = "sha256-uWWsr/wsIvVLbmxkr3z46Yo/SsJiJjCgWZxnpLnYplQ=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/herdr"
      runHook postInstall
    '';
    meta = {
      mainProgram = "herdr";
      platforms = [ "x86_64-linux" ];
    };
  };

  formattingPackages = with pkgs; [
    nixfmt
    nixfmt-tree
  ];

  cliPackages = with pkgs; [
    ghq
    delta
    tealdeer
    speedtest-cli
    betterdiscordctl
    yarn
    glow
    pandoc
    imagemagick
    direnv
    lazygit
    bat
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batwatch
    bat-extras.batdiff
    bat-extras.prettybat
    sheldon
    gh
    tree-sitter
    fzf
    croc
    xxh
    google-cloud-sdk
    hugo
    marksman
    ffsend
    clipboard-jh
    trash-cli
    # trashy
    git
  ];

  developmentPackages = with pkgs; [
    black
    isort
    python3
    # claude-code-bin
    # pi-coding-agent
  ];

  agentPackages = [
    # hermes-agent from numtide/llm-agents.nix: replaces the old pinned
    # NousResearch/hermes-agent input with numtide's cache-backed, patched
    # build of the same release.
    llmPkgs.hermes-agent
  ];

  # kitty is in desktop.nix.
  systemPackages = with pkgs; [
    ripgrep
    btop
    eza
    # google-chrome
  ];

  securityPackages = with pkgs; [
    gnupg
    openssh
    jq
    pass-git-helper
    pinentry-gnome3
    rtk
  ];
in
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.pop-shell; }
    ];
  };

  home.packages =
    formattingPackages
    ++ cliPackages
    ++ developmentPackages
    ++ agentPackages
    ++ systemPackages
    ++ securityPackages
    ++ [ herdr ];
}
