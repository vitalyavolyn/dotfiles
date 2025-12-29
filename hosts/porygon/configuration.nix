{ inputs, pkgs, config, ... }:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base-linux

    shadowsocks
    tailscale
    tailscale-exit-node

    foundry

    podman-auto-prune
    # minecraft-atm10-tts
    minecraft-ftb-stoneblock-4
    minecraft-mzhip
    {
      # modules.minecraft-atm10-tts.volumes = [ "/mnt/extra/minecraft-atm10-tts/data:/data" ];
      modules.minecraft-ftb-stoneblock-4.volumes = [ "/mnt/extra/minecraft-ftb-stoneblock-4/data:/data" ];
      modules.minecraft-mzhip.volumes = [ "/mnt/extra/minecraft-mzhip/data:/data" ];
    }

    nginx
    {
      services.nginx.clientMaxBodySize = "100m";
      services.nginx.virtualHosts = {
        "porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            return = "200 'hiiii :3'";
            extraConfig = "add_header Content-Type text/plain;";
          };
          locations."/cal/radarr" = {
            proxyPass = "http://shinx:7878/feed/v3/calendar/Radarr.ics";
          };
          locations."/cal/sonarr" = {
            proxyPass = "http://shinx:8989/feed/v3/calendar/Sonarr.ics";
          };
        };
        "hass.porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://shinx:8123/";
            proxyWebsockets = true;
          };
        };
        "foundry.porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:30000/";
            proxyWebsockets = true;
          };
        };
        "map.porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:8100";
            proxyWebsockets = true;
          };
        };
      };
    }
  ];

  # alexander manages foundry
  users.users.sanyasuper2002 = {
    isNormalUser = true;
    extraGroups = [ "foundryvtt" "wheel" ];
    shell = pkgs.zsh;
    createHome = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdbYRTexJEZuXoOUt6XazFoL1MNgGoV2muVujWvrRGk raido@starlight"
    ];
  };

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";

  home-manager.users.vitalya.home.stateVersion = "24.05";
}
