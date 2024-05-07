{ pkgs, ... }:

{
  services = {
    # TODO: separate file
    # these services are local, so api keys are fine to be public
    # (if you somehow get access to them, i encourage you to watch some pokemon)
    homepage-dashboard = {
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
          Media = [
            {
              Sonarr = {
                icon = "sonarr.png";
                href = "http://shinx.local:8989/";
                widget = {
                  type = "sonarr";
                  url = "http://localhost:8989";
                  key = "e3638f15c70f471880160883044d8e1e";
                };
              };
            }
            {
              Radarr = {
                icon = "radarr.png";
                href = "http://shinx.local:7878/";
                widget = {
                  type = "radarr";
                  url = "http://localhost:7878";
                  key = "595e6a1b41b842fca164c3edef5a1f3a";
                };
              };
            }
            {
              Jellyfin = {
                icon = "jellyfin.png";
                href = "http://shinx.local:8096/web/index.html";
                widget = {
                  type = "jellyfin";
                  url = "http://localhost:8096";
                  key = "84e958ddb3ed41e58f63fcee66515452";
                };
              };
            }
            {
              Deluge = {
                icon = "deluge.png";
                href = "http://shinx.local:8112";
                widget = {
                  type = "deluge";
                  url = "http://localhost:8112";
                  password = "deluge";
                };
              };
            }
          ];
        }
      ];
    };

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
}
