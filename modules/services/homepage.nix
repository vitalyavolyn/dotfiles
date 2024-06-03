{ lib, config, ... }:

let
  services = config.services;
  configRoot = config.modules.homepage;
  url = configRoot.baseUrl;

  # why can't ports be configured
  sonarrPort = "8989";
  sonarrKey = configRoot.sonarrKey;

  radarrPort = "7878";
  radarrKey = configRoot.radarrKey;

  bazarrPort = "6767";
  bazarrKey = configRoot.bazarrKey;

  jellyfinPort = "8096";
  jellyfinKey = configRoot.jellyfinKey;

  delugePort = toString services.deluge.web.port;

  mediaServices = lib.optionals services.sonarr.enable [
    {
      Sonarr = {
        icon = "sonarr.png";
        href = "http://${url}:${sonarrPort}/";
        widget = {
          type = "sonarr";
          url = "http://localhost:${sonarrPort}";
          key = sonarrKey;
        };
      };
    }
  ] ++ lib.optionals services.radarr.enable [
    {
      Radarr = {
        icon = "radarr.png";
        href = "http://${url}:${radarrPort}/";
        widget = {
          type = "radarr";
          url = "http://localhost:${radarrPort}";
          key = radarrKey;
        };
      };
    }
  ]++ lib.optionals services.bazarr.enable [
    {
      Bazarr = {
        icon = "bazarr.png";
        href = "http://${url}:${bazarrPort}/";
        widget = {
          type = "bazarr";
          url = "http://localhost:${bazarrPort}";
          key = bazarrKey;
        };
      };
    }
  ] ++ lib.optionals services.jellyfin.enable [
    {
      Jellyfin = {
        icon = "jellyfin.png";
        href = "http://${url}:${jellyfinPort}/web/index.html";
        widget = {
          type = "jellyfin";
          url = "http://localhost:${jellyfinPort}";
          key = jellyfinKey;
        };
      };
    }
  ] ++ lib.optionals services.deluge.enable [
    {
      Deluge = {
        icon = "deluge.png";
        href = "http://${url}:${delugePort}/";
        widget = {
          type = "deluge";
          url = "http://localhost:${delugePort}";
          password = "deluge";
        };
      };
    }
  ];
in
{
  options = {
    modules.homepage.baseUrl = lib.mkOption {
      type = lib.types.str;
      description = "Base url for homepage-dashboard";
    };
    modules.homepage.sonarrKey = lib.mkOption {
      type = lib.types.str;
      description = "Sonarr key";
    };
    modules.homepage.radarrKey = lib.mkOption {
      type = lib.types.str;
      description = "Radarr key";
    };
    modules.homepage.bazarrKey = lib.mkOption {
      type = lib.types.str;
      description = "Bazarr key";
    };
    modules.homepage.jellyfinKey = lib.mkOption {
      type = lib.types.str;
      description = "Jellyfin key";
    };
  };

  config = {
    services.homepage-dashboard = {
      enable = true;
      settings = {
        title = "Shinx";
        layout = {
          Media = {
            style = "row";
            columns = 4;
          };
        };
      };
      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
        {
          search = {
            provider = "google";
            target = "_blank";
            focus = true;
          };
        }
      ];
      services = [
        {
          Media = mediaServices;
        }
      ];
    };
  };
}
