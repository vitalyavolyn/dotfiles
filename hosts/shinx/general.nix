{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "23.11";

  users.groups.multimedia = {
    members = [ "vitalya" ];
  };
}
