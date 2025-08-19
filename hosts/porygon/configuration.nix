{ inputs, pkgs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base-linux

    shadowsocks
    { services.shadowsocks.localAddress = "0.0.0.0"; }
    tailscale
    tailscale-exit-node

    foundry

    podman-auto-prune
    minecraft-atm10
    {
      modules.minecraft-atm10.volumes = [ "/mnt/extra/minecraft-atm10/data:/data" ];
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
