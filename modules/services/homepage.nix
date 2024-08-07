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

  prowlarrPort = "9696";
  prowlarrKey = configRoot.prowlarrKey;

  jellyfinPort = "8096";
  jellyfinKey = configRoot.jellyfinKey;

  delugePort = toString services.deluge.web.port;

  mediaServices = lib.optionals services.sonarr.enable [
    {
      Sonarr = {
        icon = "sonarr.png";
        href = "${url}:${sonarrPort}/";
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
        href = "${url}:${radarrPort}/";
        widget = {
          type = "radarr";
          url = "http://localhost:${radarrPort}";
          key = radarrKey;
        };
      };
    }
  ] ++ lib.optionals services.bazarr.enable [
    {
      Bazarr = {
        icon = "bazarr.png";
        href = "${url}:${bazarrPort}/";
        widget = {
          type = "bazarr";
          url = "http://localhost:${bazarrPort}";
          key = bazarrKey;
        };
      };
    }
  ] ++ lib.optionals services.prowlarr.enable [
    {
      Prowlarr = {
        icon = "prowlarr.png";
        href = "${url}:${prowlarrPort}/";
        widget = {
          type = "prowlarr";
          url = "http://localhost:${prowlarrPort}";
          key = prowlarrKey;
        };
      };
    }
  ] ++ lib.optionals services.jellyfin.enable [
    {
      Jellyfin = {
        icon = "jellyfin.png";
        href = "${url}:${jellyfinPort}/web/index.html";
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
        href = "${url}:${delugePort}/";
        widget = {
          type = "deluge";
          url = "http://localhost:${delugePort}";
          password = "deluge";
        };
      };
    }
  ];

  homeServices = lib.optionals services.adguardhome.enable [
    {
      Adguard = {
        icon = "adguard-home.png";
        href = "${url}";
        widget = {
          type = "adguard";
          url = "http://localhost";
          username = "vitalya";
          password = "{{HOMEPAGE_VAR_ADGUARD_PASS}}";
        };
      };
    }
  ] ++ lib.optionals config.modules.home-assistant.enable [
    {
      HomeAssistant = {
        icon = "home-assistant.png";
        href = "${url}:8123";
        widget = {
          type = "homeassistant";
          url = "http://localhost:8123";
          key = "{{HOMEPAGE_VAR_HOMEASSISTANT_TOKEN}}";
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
    modules.homepage.prowlarrKey = lib.mkOption {
      type = lib.types.str;
      description = "Prowlarr key";
    };
    modules.homepage.jellyfinKey = lib.mkOption {
      type = lib.types.str;
      description = "Jellyfin key";
    };
  };

  config = {
    # TODO: should be in shinx/configuration.nix?
    age.secrets.homepage-env.file = ../../secrets/homepage-env.age;

    services.homepage-dashboard = {
      enable = true;
      environmentFile = config.age.secrets.homepage-env.path;
      settings = {
        title = "Shinx";
        layout = {
          Media = {
            style = "row";
            columns = 4;
          };
          Home = {
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
        {
          Home = homeServices;
        }
      ];
    };
  };
}
