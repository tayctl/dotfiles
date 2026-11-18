# Work desktop only; shared work config is in work.nix
{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  xdg.configFile."hypr-host/host_monitors.lua".source = link "dots/.config/hypr/taylor/monitors-work-desktop.lua";
}
