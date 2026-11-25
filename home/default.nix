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
    settings.color.ui = "auto";
    settings.pager.branch = false;
    settings.push.autoSetupRemote = true;

    # git send-email via Proton Mail SMTP submission. Always sends as the
    # personal address, including in the gitlab.com (work) context below, which
    # only overrides user.*. The SMTP token lives outside the repo and the nix
    # store, in ~/.config/git/smtp-token (chmod 600), like an SSH key.
    settings.sendemail = {
      from = "tayctl <me@sebastiantaylor.com>";
      smtpServer = "smtp.protonmail.ch";
      smtpServerPort = 587;
      smtpEncryption = "tls"; # STARTTLS
      smtpUser = "me@sebastiantaylor.com";
      envelopeSender = "me@sebastiantaylor.com";
    };

    settings.credential."smtp://smtp.protonmail.ch:587".helper =
      ''!f() { test "$1" = get && printf 'password=%s\n' "$(cat "$HOME/.config/git/smtp-token")"; }; f'';

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
    lazygit
    delta # lazygit pager

    tealdeer

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
    ".config/direnv".source = link "dots/.config/direnv";
    ".config/lazygit".source = link "dots/.config/lazygit";
    ".local/bin/fcd".source = link "scripts/fcd.sh";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
