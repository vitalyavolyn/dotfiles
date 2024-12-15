{ ... }:

{
  security.pam.enableSudoTouchIdAuth = true;
  users.users.vitalya.home = "/Users/vitalya";

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
}
