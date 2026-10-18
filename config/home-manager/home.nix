{
  pkgs,
  inputs,
  codexUpstream,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

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
    # codex — upstream openai/codex flake via the hash-injecting wrapper in
    # flake.nix (upstream's flake fails to evaluate as-is; see comment there).
    codexUpstream
    # hermes — official upstream flake (NousResearch/hermes-agent), bumped
    # manually via `nix flake lock --update-input hermes` (see flake.nix).
    inputs.hermes.packages.${system}.default
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
    ++ [ inputs.herdr.packages.${system}.herdr ];
}
