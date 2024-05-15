{ pkgs, ... }:

{
  imports = [
    ./services/homepage.nix
  ];

  services = {
    jellyfin = { enable = true; group = "multimedia"; };
    radarr = { enable = true; group = "multimedia"; };
    sonarr = { enable = true; group = "multimedia"; };
    bazarr = { enable = true; group = "multimedia"; };
    prowlarr.enable = true;
    deluge = {
      enable = true;
      group = "multimedia";
      web.enable = true;
      declarative = true;
      config = {
        enabled_plugins = [ "Label" ];
        download_location = "/mnt/media/downloads/complete";
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-auth";
        text = ''
          localclient::10
        '';
      };
    };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "eno1";
      WIFI_IFACE = "wlp1s0";
      SSID = "shinx";
      PASSPHRASE = "bulbasaur";
    };
  };
}
