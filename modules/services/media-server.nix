{ ... }:

{
  den.aspects.media-server.nixos = { ... }: {
    services = {
      plex = { enable = true; group = "multimedia"; };
      jellyfin = { enable = true; group = "multimedia"; };
      radarr = { enable = true; group = "multimedia"; };
      sonarr = { enable = true; group = "multimedia"; };
      bazarr = { enable = true; group = "multimedia"; };
      prowlarr.enable = true;
      flaresolverr.enable = true;
      qbittorrent = {
        enable = true;
        group = "multimedia";
        torrentingPort = 6881;
      };
    };

    users.groups.multimedia = {
      members = [ "vitalya" ];
    };
  };
}
