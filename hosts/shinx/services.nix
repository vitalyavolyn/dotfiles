{ pkgs, ... }:

{
  services = {
    openssh.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      # openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
      extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
    };

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
              Transmission = {
                icon = "transmission.png";
                href = "http://shinx.local:9091/transmission/web/";
                widget = {
                  type = "transmission";
                  url = "http://localhost:9091";
                };
              };
            }
          ];
        }
        {
          Misc = [
          ];
        }
      ];
    };

    adguardhome.enable = true;

    jellyfin.enable = true;
    jackett.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    bazarr.enable = true;
    transmission = {
      enable = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
        incomplete-dir = "/mnt/media/downloads/incomplete";
        download-dir = "/mnt/media/downloads/complete";
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };
}
