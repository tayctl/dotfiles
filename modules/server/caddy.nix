# Replaces Nginx Proxy Manager. Adding a service = one line in `proxies`
# plus a CNAME on the Pi-hole (<name>.theseus.home -> theseus.home).
{ lib, ... }:
let
  proxies = {
    cockpit  = 9090;
    jellyfin = 8096;
    calibre  = 8083;
    linkding = 9091;
    nullboard = 8080;
  };
in {
  services.caddy = {
    enable = true;
    # Plain HTTP only: *.home isn't a public domain, so no ACME.
    virtualHosts = lib.mapAttrs' (name: port:
      lib.nameValuePair "http://${name}.theseus.home" {
        extraConfig = "reverse_proxy 127.0.0.1:${toString port}";
      }) proxies;
  };
}
