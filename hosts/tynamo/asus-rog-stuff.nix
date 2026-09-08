{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = "options asus_nb_wmi tablet_mode_sw=3";

  # The Flow X13's built-in keyboard is exposed as two USB "Asus Keyboard"
  # interfaces (0b05:19b6). libinput otherwise treats USB keyboards as
  # external and deliberately excludes them from SW_TABLET_MODE suspension.
  # Mark this exact ASUS device internal so the tablet switch disables it
  # together with the internal I2C touchpad.
  environment.etc."libinput/local-overrides.quirks".text = ''
    [ ASUS ROG Flow X13 built-in keyboard ]
    MatchUdevType=keyboard
    MatchVendor=0x0B05
    MatchProduct=0x19B6
    AttrKeyboardIntegration=internal
  '';

  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
  };

  hardware.sensor.iio.enable = true;

  hardware.graphics = {
    enable = true;
    # extraPackages = with pkgs; [
    #   nvidia-vaapi-driver
    # ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:8:0:0";
    };
  };

}
