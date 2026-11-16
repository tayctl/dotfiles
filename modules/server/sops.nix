{ ... }: {
  sops = {
    defaultSopsFile = ../../sops/theseus.yaml;
    # theseus's ssh host key doubles as its age key
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      main-password-hash.neededForUsers = true; # mkpasswd -m yescrypt
      "linkding.env" = { };                     # LD_SUPERUSER_PASSWORD=...
      samba-main = { };
    };
  };
}
