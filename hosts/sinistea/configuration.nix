{ den, ... }:

{
  den.hosts.x86_64-linux.sinistea.users.vitalya.baseHome.extras = false;

  den.aspects.sinistea = {
    includes = with den.aspects; [
      base-linux
      docker
    ];

    nixos = { lib, ... }: {
      imports = [
        ./hardware-configuration.nix
        ./networking.nix
      ];

      # Workaround for https://github.com/NixOS/nix/issues/8502
      services.logrotate.checkConfig = false;

      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
      boot.loader.grub.device = "/dev/vda";
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;

      services.qemuGuest.enable = true;

      networking.firewall.enable = true;

      system.stateVersion = "23.11";
    };

    homeManager.home.stateVersion = "23.11";
  };
}
