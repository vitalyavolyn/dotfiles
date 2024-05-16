{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    dbeaver
    mongodb-compass
    robo3t
  ];
}
