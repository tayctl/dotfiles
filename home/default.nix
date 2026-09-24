{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.stateVersion = "24.11"; # Don't change

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

  home.packages = with pkgs; [
    # cli
    ripgrep
    fzf
    bat
    htop
    btop
    tree
    unzip
    tmux
    atuin
    direnv

    # dev
    tree-sitter
  ];

  #  programs.neovim = {
  #    enable = true;
  #    defaultEditor = true;
  #    vimAlias = true;
  #    extraPackages = with pkgs; [
  #      bash-language-server
  #      shellcheck
  #      shfmt
  #      nil
  #      nixfmt
  #    ];
  #  };

  home.file = {
    ".zshrc".source = link "dots/.zshrc";
    ".tmux.conf".source = link "dots/.tmux.conf";
    ".config/btop".source = link "dots/.config/btop";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
