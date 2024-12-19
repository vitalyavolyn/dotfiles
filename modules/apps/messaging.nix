{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
    })
    tdesktop
  ];
}
