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
  ] ++ (with inputs; [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
    agenix.nixosModules.default

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    }
  ]);

  environment.variables.FLAKE = "/etc/nixos";
}
