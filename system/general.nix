{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.cleanTmpDir = true;

  networking.hostName = "celebi";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Almaty";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
