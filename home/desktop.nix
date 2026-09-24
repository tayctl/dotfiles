{
  config,
  pkgs,
  inputs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    foot
    kitty
    waybar
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    hyprlauncher
    batsignal
    kdePackages.dolphin
    kdePackages.kio-extras
    signal-desktop
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    nerd-fonts.blex-mono
  ];

  home.file = {
    ".config/foot".source = link "dots/.config/foot";
    ".config/hypr".source = link "dots/.config/hypr";
    ".config/kitty".source = link "dots/.config/kitty";
    ".config/waybar".source = link "dots/.config/waybar";
    ".config/wofi".source = link "dots/.config/wofi";
    ".config/batsignal".source = link "dots/.config/batsignal";
    ".config/nvim".source = link "dots/.config/nvim";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
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

  fonts.fontconfig.enable = true; # without this, apps don't see the fonts

}
