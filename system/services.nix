{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.openssh.enable = true;

  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
