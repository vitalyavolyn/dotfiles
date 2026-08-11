{ inputs, ... }:

{
  den.aspects.media-server.nixos = { ... }: {
    services = {
      plex = { enable = true; group = "multimedia"; };
      jellyfin = { enable = true; group = "multimedia"; };
      radarr = {
        enable = true;
        group = "multimedia";
        settings.server.port = inputs.self.lib.homelab.portFor "radarr";
      };
      sonarr = {
        enable = true;
        group = "multimedia";
        settings.server.port = inputs.self.lib.homelab.portFor "sonarr";
      };
      bazarr = {
        enable = true;
        group = "multimedia";
        listenPort = inputs.self.lib.homelab.portFor "bazarr";
      };
      prowlarr = {
        enable = true;
        settings.server.port = inputs.self.lib.homelab.portFor "prowlarr";
      };
      flaresolverr.enable = true;
      qbittorrent = {
        enable = true;
        group = "multimedia";
        webuiPort = inputs.self.lib.homelab.portFor "torrent";
        torrentingPort = 6881;
      };
    };

    users.groups.multimedia = {
      members = [ "vitalya" ];
    };
  };
}
