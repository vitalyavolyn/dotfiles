{ pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.nh ];

  home-manager.users.vitalya.programs.zsh.shellAliases.nbs = lib.mkForce "nh darwin switch && brew upgrade -g";

  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.vitalya.home = "/Users/vitalya";
  system.primaryUser = "vitalya";

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
}
