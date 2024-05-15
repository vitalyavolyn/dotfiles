{ pkgs, ... }:

{
  services = {
    # TODO: only for hyprland
    # blueman.enable = true;

    gnome.gnome-keyring.enable = true;

    # TODO: research this
    # tlp.enable = true;

    keybase.enable = true;
    kbfs.enable = true;

    udev.extraRules = ''
      #Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", GROUP="users", TAG+="uaccess"
      #Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", GROUP="users", TAG+="uaccess"
    '';

    # thunar thumbnails
    tumbler.enable = true;
  };

  security = {
    rtkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  # may fix long shutdown idk
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=10s
  '';
}
