{ inputs, pkgs, ... }:

{
  imports = [
    inputs.foundryvtt.nixosModules.foundryvtt
  ];

  # Host must set: services.foundryvtt.hostName
  services.foundryvtt = {
    enable = true;
    minifyStaticFiles = true;
    package = inputs.foundryvtt.packages.${pkgs.stdenv.hostPlatform.system}.foundryvtt_14;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };
}
