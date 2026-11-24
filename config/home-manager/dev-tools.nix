# The dev tools every machine gets from Nix: what packages/Brew/Brewfile.common
# and Brewfile.tools installed with brew on Linux, minus the slow-moving ones
# that Ubuntu 24.04 packages. apt installs those: bat (as `batcat`), btop, eza,
# tealdeer. The rule for a tool that Ubuntu has too: it stays here if upstream
# releases about every two months or more often (fd, fish, pipx, poetry), or
# if 24.04's version is too old (neovim 0.9, LazyVim needs 0.11; nodejs 18,
# end of life), so that it tracks nixpkgs unstable.
#
# Two consumers import this file, so edit the list here only:
#   - flake.nix in this directory (Home Manager, on the non-NixOS machines)
#   - nixos-config (modules/core/dev-tools.nix), through its `dotfiles` input.
#     A change reaches the NixOS hosts after a push here, then
#     `nix flake update dotfiles` there (the auto-update does that too).
#
# macOS is not covered: it keeps installing these with brew, so the Brewfiles
# stay as they are.
#
# `inputs` must have `skillshare`; both flakes name it so.
{ pkgs, inputs }:

{
  # NixOS installs these through programs.fish, programs.starship and
  # programs.neovim, which also hook them into the system (/etc/shells, the
  # default editor). So nixos-config skips this list; Home Manager installs it
  # as plain packages.
  programs = with pkgs; [
    fish
    starship
    neovim
  ];

  packages = with pkgs; [
    # Brewfile.tools
    dust
    fd
    topgrade
    dysk
    # poetry-plugin-shell restores `poetry shell`, which poetry 2 dropped.
    (poetry.withPlugins (ps: [ ps.poetry-plugin-shell ]))
    pipx
    pyenv

    # Brewfile.common
    nodejs # includes npm
    prettier
    mermaid-cli
    devcontainer
    opencode
    inputs.skillshare.packages.${pkgs.stdenv.hostPlatform.system}.skillshare
    # Both release daily; they track nixpkgs unstable and move with
    # `nix flake update`.
    claude-code
    codex
  ];
}
