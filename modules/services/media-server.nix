{ inputs, ... }:

{
  den.aspects.media-server.nixos = { ... }:
    let
      inherit (inputs.self.lib.homelab) portFor;
    in
    {
      services = {
        plex = { enable = true; group = "multimedia"; };
        jellyfin = { enable = true; group = "multimedia"; };
        radarr = {
          enable = true;
          group = "multimedia";
          settings.server.port = portFor "radarr";
        };
        sonarr = {
          enable = true;
          group = "multimedia";
          settings.server.port = portFor "sonarr";
        };
        bazarr = {
          enable = true;
          group = "multimedia";
          settings.general.port = portFor "bazarr";
        };
        prowlarr = {
          enable = true;
          settings.server.port = portFor "prowlarr";
        };
        flaresolverr.enable = true;
        qbittorrent = {
          enable = true;
          group = "multimedia";
          webuiPort = portFor "torrent";
          torrentingPort = 6881;
        };
      };

      users.groups.multimedia = {
        members = [ "vitalya" ];
      };

      systemd.services.plex.serviceConfig.CPUWeight = 800;
      systemd.services.flaresolverr.serviceConfig.CPUWeight = 15;
    };
}
