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

  time.timeZone = "Asia/Almaty";

  users.users.vitalya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "23.11";

  security.sudo.wheelNeedsPassword = false;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      # why isnt this implied from flake.nix
      trusted-users = [ "root" "vitalya" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    speedtest-cli
    htop
  ];

  environment.variables.EDITOR = "vim";

  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
