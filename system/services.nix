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
  hardware.pulseaudio = {
    enable = true;

    # bluetooth support
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  services.openssh.enable = true;

  services.blueman.enable = true;

  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true; # TODO: doesn't unlock

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
