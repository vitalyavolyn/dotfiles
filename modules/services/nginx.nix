{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "i@vitalya.me";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
