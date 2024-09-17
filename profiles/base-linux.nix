{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user
    boot
    locale
    nix
    ssh-server
    fail2ban
  ];

  environment.variables.FLAKE = "/etc/nixos";
}
