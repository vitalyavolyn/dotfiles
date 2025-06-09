{ ... }:

{
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.vitalya.home = "/Users/vitalya";
  system.primaryUser = "vitalya";

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
}
