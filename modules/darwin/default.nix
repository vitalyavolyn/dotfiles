{ ... }:

{
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.vitalya.home = "/Users/vitalya";

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
}
