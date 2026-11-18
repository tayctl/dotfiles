{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    signal-desktop
    filen-cli
  ];

  xdg.configFile."hypr-host/monitors.conf".source = link "dots/.config/hypr/taylor/monitors.conf";
}
