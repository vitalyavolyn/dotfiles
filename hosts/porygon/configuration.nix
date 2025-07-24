{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base-linux

    shadowsocks
    { services.shadowsocks.localAddress = "0.0.0.0"; }
    tailscale
    tailscale-exit-node

    podman-auto-prune
    minecraft-atm10
    #minecraft-mzhip
    #minecraft-atm10-2
    {
      #modules.minecraft-mzhip.volumes = [ "/mnt/extra/minecraft-mzhip/data:/data" "/mnt/extra/minecraft-mzhip/mods:/mods" ];
      modules.minecraft-atm10.volumes = [ "/mnt/extra/minecraft-atm10/data:/data" ];
      # modules.minecraft-atm10-2.volumes = [ "/mnt/extra/minecraft-atm10-2/data:/data" ];
    }

    nginx
    {
      services.nginx.virtualHosts = {
        "porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            return = "200 'hiiii :3'";
            extraConfig = "add_header Content-Type text/plain;";
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
        "map.porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:8100/";
            proxyWebsockets = true;
          };
        };
        "atm10.porygon.vitalya.me" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:8101/";
            proxyWebsockets = true;
          };
        };
      };
    }
  ];

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";

  home-manager.users.vitalya.home.stateVersion = "24.05";
}
