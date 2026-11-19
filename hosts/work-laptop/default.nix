{ ... }: {

  imports = [
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/work.nix
    ../../modules/nvidia.nix
    ./hardware-configuration.nix # copy from /etc/nixos on the machine
  ];

  networking.hostName = "WorkLaptop";
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # HP Thunderbolt Dock G4: its Ethernet/USB ports sit behind a PCIe tunnel
  # that stays unauthorized without boltd running. After rebuilding, enroll
  # it once with `boltctl enroll --policy auto <uuid>` (see `boltctl list`)
  # so future connects are authorized automatically.
  services.hardware.bolt.enable = true;

  # HP ZBook Studio 16 G11: Intel Arc (Meteor Lake) + RTX 4070 Max-Q.
  # The desktop (and the dock's DisplayPort outputs) run on the Intel GPU;
  # run an app on the Nvidia GPU with `nvidia-offload <cmd>`.
  hardware.nvidia.powerManagement.finegrained = true; # power the dGPU off when idle
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
