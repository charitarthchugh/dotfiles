# Desktop apps, for the machines with a desktop
# (homeConfigurations.desktop). Add an app to the list below. It shows up in
# the app launcher after the next login: the launcher finds its .desktop file
# through ~/.config/environment.d (targets.genericLinux in common.nix).
{ pkgs, ... }:

{
  # Nix-built GUI apps cannot use the distribution's GPU drivers. This links
  # Nix-built ones (Mesa; for Nvidia see targets.genericLinux.gpu.nvidia) to
  # /run/opengl-driver. It needs root once per machine: `home-manager switch`
  # prints the `sudo non-nixos-gpu-setup` command to run, and prints it again
  # when the drivers change.
  targets.genericLinux.gpu.enable = true;

  # So the apps find fonts installed with Nix too.
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    kitty
  ];
}
