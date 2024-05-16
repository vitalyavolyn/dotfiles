{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base

    shadowsocks
    minecraft-aof6
    {
      services.minecraft-aof6.volumes = [ "/mnt/extra/minecraft-aof6/data:/data" ];
    }
  ] ++ [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";
}

