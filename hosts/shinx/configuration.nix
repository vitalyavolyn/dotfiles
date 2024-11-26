{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-budgie

    media-server
    { services.deluge.config.download_location = "/mnt/media/downloads/complete"; }

    homepage
    {
      modules.homepage = {
        baseUrl = "http://shinx.local";
        # these services are local, so api keys are fine to be public
        # (if you somehow get access to them, i encourage you to watch some pokemon)
        sonarrKey = "f63ac2c47c514fb5b44d3d73adec183e";
        radarrKey = "c703983ff599433785182afc1b91ea84";
        bazarrKey = "f33e058ffcbe7250bfa777b9231e2125";
        prowlarrKey = "2747ae3760784638b271cea5611c4b11";
        jellyfinKey = "dd16672806394eaeae1e5e4000d136a3";
      };
    }

    home-assistant
    { modules.home-assistant.volumes = [ "/mnt/media/home-assistant:/config" ]; }

    caddy
    {
      services.caddy.virtualHosts = {
        "shinx-ts.ewe-lizard.ts.net".extraConfig = ''
          # smithereen
          #reverse_proxy :4567
          #reverse_proxy /i/* :4560
          #handle /s/* {
          #  root * /var/www/smithereen
          #  file_server
          #}
          # imgproxy for my server
          #reverse_proxy /m/* :4561
        '';
      };
    }

    podman-auto-prune

    miniflux

    tailscale
    avahi
    docker
    browser
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "23.11";

  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "eno1";
      WIFI_IFACE = "wlp1s0";
      SSID = "shinx";
      # i know it's public
      # are you me neighbor? probably not
      # this is a temp solution, my access point is shit
      PASSPHRASE = "bulbasaur";
    };
  };
}
