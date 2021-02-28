{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # last two fix the touchpad
  boot.kernelParams = [ "quiet splash" "i8042.nopnp=1" "pci=nocrs" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/4fe659ab-5568-4a0d-ab34-c121c4054971";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1B3A-DD8D";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/b6a2ab5f-b741-4785-bf46-2847964c9a02"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
  ];

  hardware.bluetooth.enable = true;
}
