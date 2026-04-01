{ inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix

    inputs.self.nixosProfiles.base-linux
  ];

  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.device = "/dev/vda";
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.qemuGuest.enable = true;

  networking.hostName = "sinistea";
  networking.firewall.enable = true;

  system.stateVersion = "23.11";

  home-manager.users.vitalya.home.stateVersion = "23.11";
}
