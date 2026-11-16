# Things without a good NixOS module stay as podman containers.
{ ... }: {
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers = {
    linkding = {
      image = "docker.io/sissbruecker/linkding:latest";
      ports = [ "127.0.0.1:9091:9090" ];
      volumes = [ "/var/lib/linkding:/etc/linkding/data" ];
      environment.LD_SUPERUSER_NAME = "taylor";
      # Password: not in the store. Put LD_SUPERUSER_PASSWORD=... in this file by hand.
      environmentFiles = [ "/var/lib/secrets/linkding.env" ];
    };
    nullboard = {
      image = "docker.io/luismedel/nullboard:latest";
      ports = [ "127.0.0.1:8080:80" ];
      volumes = [ "/var/lib/nullboard:/data" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/linkding 0755 root root -"
    "d /var/lib/nullboard 0775 1000 1000 -"
    "d /var/lib/secrets 0700 root root -"
  ];
}
