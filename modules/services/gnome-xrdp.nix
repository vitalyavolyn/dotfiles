{ pkgs, ... }:

{
  services.gnome.gnome-remote-desktop.enable = true;

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  environment.systemPackages = with pkgs; [
    gnome-session
  ];
}
