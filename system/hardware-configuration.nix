{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")

      <nixos-hardware/common/cpu/intel>
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/pc/ssd>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];
  # last two fix the touchpad
  boot.kernelParams = [ "quiet" "splash" "i8042.nopnp=1" "pci=nocrs" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.bluetooth.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      ocl-icd
    ];
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "modesetting" ];
}
