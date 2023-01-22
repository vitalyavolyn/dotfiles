{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      layout = "us,ru";
      xkbOptions = "grp:alt_shift_toggle";

      wacom.enable = true;

      # videoDrivers = [ "intel" ];
      # deviceSection = ''
      # Option "TearFree" "true"
      # Option "TripleBuffer" "true"
      # Option "DRI" "false"
      # '';

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

    sshd.enable = true;
    blueman.enable = true;

    gnome.gnome-keyring.enable = true;

    fstrim.enable = true;
    tlp.enable = true;

    udev.extraRules = ''
      #Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", GROUP="users", TAG+="uaccess"
      #Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", GROUP="users", TAG+="uaccess"
    '';
  };
  
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # virtualisation.virtualbox.host.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  # for work VPN
  networking.networkmanager.enableStrongSwan = true;
  services.xl2tpd.enable = true;
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };
}
