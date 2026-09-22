{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "taylor";
  home.homeDirectory = "/home/taylor";

  programs.git = {
    enable = true;
    userName = "tayctl";
    userEmail = "me@sebastiantaylor.com";

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@gitlab.com:**";
        contents.user = {
          name = "s232633";
          email = "s2326332@dtu.dk";
        };
      }
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.stateVersion = "24.11"; # Don't change

  home.packages = with pkgs; [
    foot
    ripgrep
    fzf
    htop
    tree
    bat
    direnv
    atuin
    unzip
    tmux
    tree-sitter
    tree-sitter-cli
  ];

  home.file = {
    ".zshrc".source = ../../.zshrc;
    ".tmux.conf".source = ../../.tmux.conf;
    ".config/foot".source = ../foot;
    ".config/hypr".source = ../hypr;
    ".config/kitty".source = ../kitty;
    ".config/waybar".source = ../waybar;
    ".config/wofi".source = ../wofi;
    ".config/btop".source = ../btop;
    ".config/batsignal".source = ../batsignal;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
