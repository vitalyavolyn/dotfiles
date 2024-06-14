{ pkgs, ... }:

{
  services.gnome.gnome-remote-desktop.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome3.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  environment.systemPackages = with pkgs; [
    gnome3.gnome-session
  ];
}
