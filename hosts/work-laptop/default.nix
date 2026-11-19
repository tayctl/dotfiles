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

  # Always docked on AC, so there's no battery life to trade away: pin
  # intel_pstate to performance instead of letting it idle clocks down
  # under the default powersave/balance_power EPP even at full load.
  # The governor alone doesn't move intel_pstate's EPP off "default", so
  # set that explicitly too (glob covers every cpuN, not cpufreq/cpuidle).
  powerManagement.cpuFreqGovernor = "performance";
  boot.kernel.sysfs.devices.system.cpu."cpu[0-9]*".cpufreq.energy_performance_preference = "performance";

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
