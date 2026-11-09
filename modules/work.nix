{ username, ... }: {
  users.users.${username} = {
    description = "Sebastian";
    # serial access for minicom (/dev/ttyUSB*, /dev/ttyACM*)
    extraGroups = [ "dialout" ];
  };
}
