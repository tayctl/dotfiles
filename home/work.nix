{
  config,
  pkgs,
  lib,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    minicom
    claude-code
    teams-for-linux
    devenv
    android-tools # adb, fastboot
    openfortivpn
    git-repo
    docker
    podman
  ];

  # Work identity by default, personal identity for my own GitHub repos
  programs.git = {
    settings.user = lib.mkForce {
      name = "Sebastian Francis Taylor";
      email = "sft@sky-watch.com";
    };
    includes =
      map
        (pattern: {
          condition = "hasconfig:remote.*.url:${pattern}";
          contents.user = {
            name = "tayctl";
            email = "me@sebastiantaylor.com";
          };
        })
        [
          "git@github.com:tayctl/**"
          "https://github.com/tayctl/**"
        ];
  };

  # Keys are not in this repo: copy them to ~/.ssh by hand (chmod 600)
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*.sky-watch.com" = {
        User = "sft4";
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "bitbucket.org ssh.bitbucket.org" = {
        IdentityFile = "~/.ssh/id_rsa";
        IdentitiesOnly = "yes";
      };
      "github.com" = {
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = "yes";
      };
    };
  };

  home.file.".local/bin/yb".source = link "scripts/yocto/yb.sh";

  # Monitors are per machine: home/work-laptop.nix, home/work-desktop.nix
  xdg.configFile."hypr-host/host_autostart.lua".source =
    link "dots/.config/hypr/taylor/autostart-work.lua";
}
