{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true; # required for Wayland
    open = true; # Turing (RTX 20xx / GTX 16xx) or newer; set false for older cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true; # fixes corruption after suspend
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
  };
}
