{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    signal-desktop
    filen-cli
    pika-backup
  ];

  xdg.configFile."hypr-host/host_monitors.lua".source = link "dots/.config/hypr/taylor/monitors.lua";
  xdg.configFile."hypr-host/host_autostart.lua".source = link "dots/.config/hypr/taylor/autostart-personal.lua";
}
