{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = "options asus_nb_wmi tablet_mode_sw=3";

  # built-in keyboard is USB, so mark it internal for tablet mode to disable it
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

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
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
