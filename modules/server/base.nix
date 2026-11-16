{ config, pkgs, ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "main" ];
  };

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.main = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.main-password-hash.path;
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... taylor@laptop"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Replaces Cockpit's terminal/updates; UI at cockpit.theseus.home
  services.cockpit = {
    enable = true;
    port = 9090;
    allowed-origins = [ "http://cockpit.theseus.home" ];
  };

  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  # Nothing is backed up (see homelab README), but keep the store tidy.
  nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };

  environment.systemPackages = with pkgs; [ git vim htop ];
}
