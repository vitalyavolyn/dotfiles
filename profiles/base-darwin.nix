{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user
  ];

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
