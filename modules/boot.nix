{ pkgs, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };
}
