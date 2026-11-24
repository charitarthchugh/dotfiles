# The packages of the machine that used this flake first
# (homeConfigurations.humara). The dev tools that every machine gets (fish,
# neovim, nodejs, poetry, fd, claude-code, codex, herdr, ...) come from
# dev-tools.nix through common.nix, shared with the NixOS hosts. Do not list
# one of them here too: when the two builds differ, the build fails with a
# collision.
{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  llmPkgs = inputs.llm-agents.packages.${system};

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
    ++ securityPackages;
}
