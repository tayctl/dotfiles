{ ... }: {

  imports = [
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/work.nix
    ../../modules/nvidia.nix
    ./hardware-configuration.nix # copy from /etc/nixos on the machine
  ];

  networking.hostName = "WorkDesktop";
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nvidia is the only GPU here, so send everything to it
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
