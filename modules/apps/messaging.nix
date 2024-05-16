{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    # webcord
    (discord.override {
      withOpenASAR = true;
    })
    tdesktop
  ];
}
