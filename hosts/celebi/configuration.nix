{ ... }:

{
  imports =
    [
      # hardware-specific config,
      # see also flake.nix -> nixos-hardware modules
      ./system/hardware-configuration.nix

      ./system/general.nix
      ./system/services.nix
      ./system/packages.nix
    ];
}
