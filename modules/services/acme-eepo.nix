{ config, ... }:

{
  age.secrets.cloudflare-acme.file = ../../secrets/cloudflare-acme.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "i@vitalya.me";
    certs."eepo.boo" = {
      group = "nginx";
      domain = "eepo.boo";
      extraDomainNames = [ "*.eepo.boo" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      environmentFile = config.age.secrets.cloudflare-acme.path;
    };
  };
}
