{ ... }: {

  imports = [
    ../../modules/common.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ThinkNix";
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
