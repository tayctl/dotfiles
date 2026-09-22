{
  config,
  pkgs,
  lib,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles"; # adjust if your repo lives elsewhere
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.username = "taylor";
  home.homeDirectory = "/home/taylor";

  programs.git = {
    enable = true;

    settings.user = {
      name = "tayctl";
      email = "me@sebastiantaylor.com";
    };

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
  ];

  home.file = {
    ".zshrc".source = link "dots/.zshrc";
    ".tmux.conf".source = link "dots/.tmux.conf";
    ".config/foot".source = link "dots/.config/foot";
    ".config/hypr".source = link "dots/.config/hypr";
    ".config/kitty".source = link "dots/.config/kitty";
    ".config/waybar".source = link "dots/.config/waybar";
    ".config/wofi".source = link "dots/.config/wofi";
    ".config/btop".source = link "dots/.config/btop";
    ".config/batsignal".source = link "dots/.config/batsignal";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
