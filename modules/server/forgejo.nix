{ ... }: {
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    database.type = "sqlite3"; # plenty for a home server; no extra service to run
    settings = {
      server = {
        DOMAIN = "forgejo.theseus.home";
        ROOT_URL = "http://forgejo.theseus.home/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        # Git over ssh uses the host's sshd on port 22
        SSH_DOMAIN = "theseus.home";
      };
      service.DISABLE_REGISTRATION = true; # create users via CLI/admin
    };
  };
  # Data in /var/lib/forgejo. First admin, after first boot:
  #   sudo -u forgejo forgejo admin user create --admin --username taylor \
  #     --email me@sebastiantaylor.com --password '<pw>'
  # (run with --work-path /var/lib/forgejo --config /var/lib/forgejo/custom/conf/app.ini if needed)
}
