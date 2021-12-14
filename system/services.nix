{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";

    videoDrivers = ["intel"];
    deviceSection = ''
      Option "TearFree" "true"
      Option "TripleBuffer" "true"
      Option "DRI" "false"
    '';

    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };

    displayManager = {
      defaultSession = "xfce+i3";
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

  services.sshd.enable = true;

  services.blueman.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.fstrim.enable = true;

  services.tlp.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
