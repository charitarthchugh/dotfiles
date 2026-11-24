# Desktop apps, for the machines with a desktop
# (homeConfigurations.desktop). Add an app to the list below. It shows up in
# the app launcher after the next login: the launcher finds its .desktop file
# through ~/.config/environment.d (targets.genericLinux in common.nix).
{ pkgs, inputs, ... }:

let
  devTools = import ./dev-tools.nix { inherit pkgs inputs; };
in
{
  # Nix-built GUI apps cannot use the distribution's GPU drivers. This links
  # Nix-built ones (Mesa; for Nvidia see targets.genericLinux.gpu.nvidia) to
  # /run/opengl-driver. It needs root once per machine: `home-manager switch`
  # prints the `sudo non-nixos-gpu-setup` command to run, and prints it again
  # when the drivers change.
  targets.genericLinux.gpu.enable = true;

  # So the apps find fonts installed with Nix too.
  fonts.fontconfig.enable = true;

  # The desktop session's shell extension, only where there is a session.
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.pop-shell; }
    ];
  };

  # The desktop apps of the shared dev tools (herdr-app).
  home.packages = devTools.desktopPackages;
}
