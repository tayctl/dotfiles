{ ... }: {
  imports = [
    ./base.nix
    ./sops.nix
    ./caddy.nix
    ./jellyfin.nix
    ./calibre.nix
    ./containers.nix
    ./forgejo.nix
    ./samba.nix
  ];
}
