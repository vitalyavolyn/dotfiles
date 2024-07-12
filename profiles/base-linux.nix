{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    boot
    locale
    nix
    ssh-server
    user
    zsh
    fail2ban
  ];

  environment.variables.FLAKE = "/etc/nixos";
}
