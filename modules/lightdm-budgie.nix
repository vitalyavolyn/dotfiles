{ ... }:

{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.budgie.enable = true;
    layout = "us";
    xkbVariant = "";
  };
}