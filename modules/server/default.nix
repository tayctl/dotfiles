{ ... }: {
  imports = [
    ./base.nix
    ./caddy.nix
    ./jellyfin.nix
    ./calibre.nix
    ./containers.nix
    ./samba.nix
  ];
}
