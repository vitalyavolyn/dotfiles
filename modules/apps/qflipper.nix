{ pkgs, ... }:

{
  home-manager.users.vitalya.home.packages = with pkgs; [
    qFlipper
  ];

  services.udev.extraRules = ''
    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", GROUP="users", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", GROUP="users", TAG+="uaccess"
  '';
}
