{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user
    nix
    darwin # general tweaks
    brew
    # TODO:
    # ssh server?
    fonts
  ];

  services.nix-daemon.enable = true;

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
