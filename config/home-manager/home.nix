{ config, pkgs, ... }:

let
  herdr = pkgs.stdenv.mkDerivation {
    pname = "herdr";
    version = "0.7.1";
    src = pkgs.fetchurl {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v0.7.1/herdr-linux-x86_64";
      sha256 = "0m56v2ws8rwwb6h309k2q953z2p9z1yayr3cdr5za8iczjpsqrdr";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/herdr
      runHook postInstall
    '';
    meta.mainProgram = "herdr";
  };
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

  home.packages = with pkgs; [
    nixfmt
    nixfmt-tree
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
    black
    isort
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
    python3
    nodejs
    prettier
    mermaid-cli
    opencode
    # claude-code-bin
    codex
    # pi-coding-agent
    ripgrep
    btop
    dust
    eza
    poetry
    pyenv
    dysk
    kitty
    fish

    gnupg
    openssh
    jq
    pass-git-helper
    pinentry-gnome3
    

    # google-chrome
    rtk
    herdr
    
  ];
}
