{ config, pkgs, ... }:

{
  imports =
    [
      ./system/hardware-configuration.nix # hardware-specific config

      ./system/fonts.nix
      ./system/general.nix
      ./system/services.nix
      ./system/packages.nix

      ./users/users.nix
    ];

  system.stateVersion = "20.09";
  # TODO: garbage collection
}
