{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      # TODO: get rid of xfce4-* and add an actual notifications daemon
      desktopManager.xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };

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

    udev.extraRules = ''
      #Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", GROUP="users", TAG+="uaccess"
      #Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", GROUP="users", TAG+="uaccess"
    '';
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # TODO: these options are disabled now, may have broken BT audio in the process
    #media-session.config.bluez-monitor.rules = [
    #  {
    #    # Matches all cards
    #    matches = [{ "device.name" = "~bluez_card.*"; }];
    #    actions = {
    #      "update-props" = {
    #        "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
    #        # mSBC is not expected to work on all headset + adapter combinations.
    #        "bluez5.msbc-support" = true;
    #        # SBC-XQ is not expected to work on all headset + adapter combinations.
    #        "bluez5.sbc-xq-support" = true;
    #      };
    #    };
    #  }
    #  {
    #    matches = [
    #      # Matches all sources
    #      { "node.name" = "~bluez_input.*"; }
    #      # Matches all outputs
    #      { "node.name" = "~bluez_output.*"; }
    #    ];
    #    actions = {
    #      "node.pause-on-idle" = false;
    #    };
    #  }
    #];
  };

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
