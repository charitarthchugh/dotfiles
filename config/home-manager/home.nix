{ config, pkgs, ... }:

{
  home.username = "humara";
  home.homeDirectory = "/home/humara";
  home.stateVersion = "25.10";

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
    fzf
    croc
    eza
    xxh
    google-cloud-sdk
    fd
    hugo
    marksman
    ffsend
    clipboard-jh

    git
    python3
    nodejs
    prettier
    mermaid-cli
    opencode
    claude-code
    codex

    btop
    dust
    eza
    poetry
    pipx
    pyenv
    dysk
    kitty
    fish

    gnupg
    openssh
    jq

    google-chrome
  ];
}
