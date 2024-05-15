{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    boot
    nix
    locale
    required-packages
    user
    zsh
  ];

  environment.variables.FLAKE = "/etc/nixos";
}
