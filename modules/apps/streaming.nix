{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    obs-studio
  ];
}
