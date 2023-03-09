{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cc";
  home.homeDirectory = "/home/cc";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = [
    pkgs.nixfmt
    pkgs.topgrade
    pkgs.ghq
    pkgs.go
    pkgs.flutter
    pkgs.delta
    pkgs.tldr
    pkgs.speedtest-cli
    pkgs.betterdiscordctl
    pkgs.yarn
    pkgs.glow
    pkgs.pandoc
    pkgs.imagemagick
    pkgs.direnv
    pkgs.cmake
    pkgs.lazygit
    pkgs.bat
    pkgs.bat-extras.batman
    pkgs.bat-extras.batgrep
    pkgs.bat-extras.batwatch
    pkgs.bat-extras.batdiff
    pkgs.bat-extras.prettybat
    pkgs.black
    pkgs.isort
    pkgs.starship
    pkgs.sheldon
    pkgs.du-dust
    pkgs.gh
    pkgs.neovim
    pkgs.fzf
    pkgs.croc
    pkgs.rars
    pkgs.exa
    pkgs.xxh
    pkgs.google-cloud-sdk
    pkgs.fd
    pkgs.hugo
  ];
}

