{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base
    inputs.self.nixosProfiles.home

    media-server
    { services.deluge.config.download_location = "/mnt/media/downloads/complete"; }

    homepage
    {
      services.homepage-dashboard = {
        baseUrl = "http://shinx.local";
        # these services are local, so api keys are fine to be public
        # (if you somehow get access to them, i encourage you to watch some pokemon)
        sonarrKey = "f63ac2c47c514fb5b44d3d73adec183e";
        radarrKey = "c703983ff599433785182afc1b91ea84";
        jellyfinKey = "dd16672806394eaeae1e5e4000d136a3";
      };
    }

    chrome
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "23.11";
}
