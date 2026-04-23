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
    ({ pkgs, ... }: {
      environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix ];
    })

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

  services.fwupd.enable = true;

  environment.variables.FLAKE = "/etc/nixos";
  environment.variables.NH_FLAKE = "/etc/nixos";
}
