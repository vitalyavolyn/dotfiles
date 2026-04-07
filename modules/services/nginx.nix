{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    resolver.addresses = [ "100.100.100.100" ]; # Tailscale internal DNS — resolves hostnames at runtime
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "i@vitalya.me";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
