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
    topgrade
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
    starship
    sheldon
    gh
    neovim
    tree-sitter
    fzf
    croc
    xxh
    google-cloud-sdk
    fd
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
    nodejs
    prettier
    mermaid-cli
    opencode
    # claude-code-bin
    # pi-coding-agent
  ];

  agentPackages = [
    # codex + hermes-agent — from numtide/llm-agents.nix. codex:
    # openai's own flake is broken (openai/codex#3453). hermes: replaces the
    # old pinned NousResearch/hermes-agent input with numtide's cache-backed,
    # patched build of the same v2026.8.19 tag.
    llmPkgs.codex
    llmPkgs.hermes-agent
  ];

  systemPackages = with pkgs; [
    ripgrep
    btop
    dust
    eza
    poetry
    pyenv
    dysk
    kitty
    fish
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
  home.username = "humara";
  home.homeDirectory = "/home/humara";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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
