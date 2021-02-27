{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # last two fix the touchpad. TODO: move to hardware?
  boot.kernelParams = [ "quiet splash" "i8042.nopnp=1" "pci=nocrs" ];
  boot.cleanTmpDir = true;

  networking.hostName = "celebi";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Almaty";

  i18n.inputMethod.enabled = "ibus";
}
