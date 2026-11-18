{ pkgs, lib, username, ... }: {
  users.users.${username} = {
    description = "Sebastian";
    # serial access for minicom (/dev/ttyUSB*, /dev/ttyACM*)
    extraGroups = [ "dialout" ];
    # subuid/subgid ranges for rootless podman (yb)
    autoSubUidGidRange = true;
  };

  # yb (scripts/yocto/yb.sh) runs Yocto builds in the team's container
  virtualisation.podman.enable = true;

  # Work VPN: import the .ovpn with
  #   nmcli connection import type openvpn file work.ovpn
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  environment.systemPackages = [ pkgs.openvpn ];

  # wpa_supplicant instead of iwd: avoids iwd's corrupted-.psk "secrets were
  # required but not provided" failures seen on work wifi
  networking.networkmanager.wifi.backend = lib.mkForce "wpa_supplicant";
}
