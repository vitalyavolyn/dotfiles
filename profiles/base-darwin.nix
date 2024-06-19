{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
  ];

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
