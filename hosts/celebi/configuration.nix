{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.celebi.users.vitalya = { };

  den.aspects.celebi = {
    includes = with den.aspects; [
      desktop-gnome
      gnome-xrdp
      tailscale
      dev
      spotify
      qflipper
      messaging
      torrent
      chrome
      minecraft
      krita
      streaming
      vlc
      steam-run
      docker
    ];

    nixos = {
      imports = with inputs.nixos-hardware.nixosModules; [
        ./hardware-configuration.nix
        common-pc-laptop
        common-pc-ssd
        common-cpu-intel
      ];

      networking = {
        networkmanager.enable = true;
        firewall.enable = false;
      };

      system.stateVersion = "20.09";
    };

    homeManager.home.stateVersion = "20.09";
  };
}
