{ ... }:

{
  den.aspects.nginx.nixos = { ... }: {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      resolver.addresses = [ "100.100.100.100" ];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "i@vitalya.me";
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
