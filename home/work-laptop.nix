# Work laptop only (HP ZBook Studio 16 G11); shared work config is in work.nix
{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = [ pkgs.kanshi ];

  # Docked to the 4K monitor most of the time: kanshi turns the built-in
  # screen off while an external monitor is connected
  xdg.configFile."hypr-host/host_monitors.lua".source = link "dots/.config/hypr/taylor/monitors-work-laptop.lua";
  xdg.configFile."kanshi/config".text = ''
    profile docked {
      output eDP-1 disable
      output * mode preferred position 0,0 scale 1.5
    }

    profile undocked {
      output eDP-1 enable mode preferred position 0,0 scale 1.5
    }
  '';
}
