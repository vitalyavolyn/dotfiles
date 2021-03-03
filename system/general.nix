{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;

  networking.hostName = "celebi";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Almaty";

  i18n.inputMethod.enabled = "ibus";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
