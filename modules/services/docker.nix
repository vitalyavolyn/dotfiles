{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    docker-compose
  ];
}
