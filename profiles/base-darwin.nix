{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user

    # TODO:
    # nix
    # ssh server?
  ];

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
