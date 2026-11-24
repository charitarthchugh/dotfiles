# What every Home Manager machine gets: the dev tools shared with the NixOS
# hosts (dev-tools.nix). desktop.nix adds the desktop apps on machines with a
# desktop.
{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  devTools = import ./dev-tools.nix { inherit pkgs inputs; };
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

  home.packages = devTools.programs ++ devTools.packages;
}
