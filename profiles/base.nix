{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    boot
    locale
    nix
    user
    zsh
  ];

  environment.variables.FLAKE = "/etc/nixos";
}
