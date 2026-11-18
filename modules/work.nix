{ username, ... }: {
  users.users.${username} = {
    description = "Sebastian";
    # serial access for minicom (/dev/ttyUSB*, /dev/ttyACM*)
    extraGroups = [ "dialout" ];
    # subuid/subgid ranges for rootless podman (yb)
    autoSubUidGidRange = true;
  };

  # yb (scripts/yocto/yb.sh) runs Yocto builds in the team's container
  virtualisation.podman.enable = true;
}
