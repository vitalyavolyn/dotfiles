{ pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    pavucontrol
  ];
}
