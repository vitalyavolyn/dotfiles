{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base

    shadowsocks
    minecraft-aof6
    {
      services.minecraft-aof6.volumes = [ "/mnt/extra/minecraft-aof6/data:/data" ];
    }
  ];

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";
}

