{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    foot
    kitty
    waybar
    wofi
    batsignal
    kdePackages.dolphin
    kdePackages.kio-extras
  ];

  home.file = {
    ".config/foot".source = link "dots/.config/foot";
    ".config/hypr".source = link "dots/.config/hypr";
    ".config/kitty".source = link "dots/.config/kitty";
    ".config/waybar".source = link "dots/.config/waybar";
    ".config/wofi".source = link "dots/.config/wofi";
    ".config/batsignal".source = link "dots/.config/batsignal";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
