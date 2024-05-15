{ ... }:

{
  # these services are local, so api keys are fine to be public
  # (if you somehow get access to them, i encourage you to watch some pokemon)

  # TODO: get ports from config
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
        Media = [
          {
            Sonarr = {
              icon = "sonarr.png";
              href = "http://shinx.local:8989/";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "f63ac2c47c514fb5b44d3d73adec183e";
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
                key = "c703983ff599433785182afc1b91ea84";
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
                key = "dd16672806394eaeae1e5e4000d136a3";
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
}
