{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    boot
    docker # TODO: keep, but remove from base. shinx and porygon use podman (or switch them to docker)
    locale
    nix
    ssh-server
    user
    zsh
  ];

  environment.variables.FLAKE = "/etc/nixos";
}
