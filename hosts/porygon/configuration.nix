{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base

    shadowsocks
    tailscale

    minecraft-aof6
    {
      modules.minecraft-aof6.volumes = [ "/mnt/extra/minecraft-aof6/data:/data" ];
    }

    nginx
    {
      services.nginx.virtualHosts."hass.porygon.vitalya.me" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://shinx-ts:8123/";
          proxyWebsockets = true;
        };
      };
    }
  ];

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";
}

