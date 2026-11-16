{ ... }: {
  services.jellyfin = {
    enable = true;
    user = "main"; # so media in ~/media is readable/writable without SELinux fuss
    group = "users";
  };
  # Config lives in /var/lib/jellyfin. Libraries: /home/main/media/{movies,shows,music}
  systemd.tmpfiles.rules = [
    "d /home/main/media 0775 main users -"
    "d /home/main/media/movies 0775 main users -"
    "d /home/main/media/shows 0775 main users -"
    "d /home/main/media/music 0775 main users -"
  ];
  # Only reachable through Caddy; bind loopback in the web UI if desired.
}
