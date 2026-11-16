# Sketch of the homelab server "theseus" (replaces Fedora Server + podman + NPM).
# TODO: generate hardware-configuration.nix on the machine with
#   nixos-generate-config --show-hardware-config
{ ... }: {

  imports = [
    ../../modules/server
    # ./hardware-configuration.nix
  ];

  networking.hostName = "theseus";
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Placeholder so `nix eval` works before real hardware config exists.
  # Single-disk plain btrfs; the generated hardware-configuration.nix will replace this.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" ];
  };
  services.btrfs.autoScrub.enable = true;

  # Static IP is handled by the Asus router's DHCP reservation (192.168.50.220),
  # so plain DHCP here.
  networking.useDHCP = true;
}
