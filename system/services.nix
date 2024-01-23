{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      # desktopManager.pantheon.enable = true;

      displayManager = {
        defaultSession = "hyprland";
        # lightdm = {
        sddm = {
          enable = true;
        };
      };
    };

    sshd.enable = true;
    blueman.enable = true;

    gnome.gnome-keyring.enable = true;

    fstrim.enable = true;
    tlp.enable = true;

    keybase.enable = true;
    kbfs.enable = true;

    udev.extraRules = ''
      #Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", GROUP="users", TAG+="uaccess"
      #Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", GROUP="users", TAG+="uaccess"
    '';

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

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
