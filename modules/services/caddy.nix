{ ... }:

{
  services.caddy = {
    enable = true;
  };

  services.tailscale.permitCertUid = "caddy";

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
