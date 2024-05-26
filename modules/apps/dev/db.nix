{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    dbeaver-bin
    mongodb-compass
    robo3t
  ];
}
