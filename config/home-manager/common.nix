# What every Home Manager machine gets: the dev tools shared with the NixOS
# hosts (dev-tools.nix) plus the rest of the CLI stack. Installations are not
# machine-specific; desktop.nix adds the desktop apps on machines with a
# desktop.
{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  devTools = import ./dev-tools.nix { inherit pkgs inputs; };

  system = pkgs.stdenv.hostPlatform.system;
  llmPkgs = inputs.llm-agents.packages.${system};

  formattingPackages = with pkgs; [
    nixfmt
    nixfmt-tree
  ];

  # The rule for a tool Ubuntu 24.04 also ships (dev-tools.nix states it in
  # full): keep it here only if upstream releases about every two months or
  # more often, or 24.04's version is too old. The rest come from apt.
  cliPackages = with pkgs; [
    # Not in Ubuntu.
    ghq
    betterdiscordctl
    yarn
    glow
    lazygit
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batwatch
    bat-extras.batdiff
    bat-extras.prettybat
    sheldon
    tree-sitter
    croc
    xxh
    google-cloud-sdk
    marksman
    ffsend
    clipboard-jh
    # In Ubuntu; kept for release cadence or age of the 24.04 build.
    delta # apt name: git-delta
    gh
    fzf
    hugo
  ];

  developmentPackages = with pkgs; [
    isort
  ];

  agentPackages = [
    # hermes-agent from numtide/llm-agents.nix: cache-backed, patched build.
    llmPkgs.hermes-agent
  ];

  securityPackages = with pkgs; [
    rtk
  ];
in
{
  programs.home-manager.enable = true;

  # Every machine of this flake is a Linux distribution other than NixOS:
  # puts the Nix profile's share/ (completions, man pages, .desktop files,
  # icons) on XDG_DATA_DIRS, for the shells and, through
  # ~/.config/environment.d, the desktop session.
  targets.genericLinux.enable = true;
  # GPU drivers are only for GUI apps; desktop.nix turns them on.
  targets.genericLinux.gpu.enable = lib.mkDefault false;

  home.packages =
    devTools.programs
    ++ devTools.packages
    ++ formattingPackages
    ++ cliPackages
    ++ developmentPackages
    ++ agentPackages
    ++ securityPackages;
}
