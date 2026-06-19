{ inputs, pkgs, ... }:

{
  imports = [
    inputs.foundryvtt.nixosModules.foundryvtt
  ];

  services.foundryvtt = {
    enable = true;
    # FIXME/TODO: move this stuff to options
    hostName = "foundry.eepo.boo";
    minifyStaticFiles = true;
    package = inputs.foundryvtt.packages.${pkgs.stdenv.hostPlatform.system}.foundryvtt_14;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };
}
