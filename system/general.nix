{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    plymouth.enable = true;
  };

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Almaty";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.vitalya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "input" ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;
}
