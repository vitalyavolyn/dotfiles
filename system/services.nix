{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.desktopManager.pantheon = {
    enable = true;
    extraWingpanelIndicators = [ pkgs.pantheon.wingpanel-indicator-keyboard ];
  };
  environment.pantheon.excludePackages = with pkgs; [ gnome3.geary pantheon.elementary-code ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh.enable = true;
}
