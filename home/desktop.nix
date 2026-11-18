{
  config,
  pkgs,
  inputs,
  ...
}:
let
  zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
    zen
    nerd-fonts.blex-mono

    # launched by the Hyprland config (autostart.lua, keybinds.lua)
    dunst
    udiskie
    cliphist
    wl-clipboard
    networkmanagerapplet
    brightnessctl
    playerctl
    hyprshot
    wofi
    iwgtk
  ];

  home.file = {
    ".config/foot".source = link "dots/.config/foot";
    ".config/hypr".source = link "dots/.config/hypr";
    ".config/kitty".source = link "dots/.config/kitty";
    ".config/waybar".source = link "dots/.config/waybar";
    ".config/wofi".source = link "dots/.config/wofi";
    ".config/batsignal".source = link "dots/.config/batsignal";
    ".config/nvim".source = link "dots/.config/nvim";

    ".local/bin/power-menu".source = link "scripts/power-menu.sh";
    # programs.lua launches zen-browser, the flake's binary is called zen
    ".local/bin/zen-browser".source = "${zen}/bin/zen";

  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
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
