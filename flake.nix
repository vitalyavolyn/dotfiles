{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nix-darwin, ... } @ inputs:
    let
      globalModules = [
        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        }
      ];
    in
    {
      nixosModules = (import ./modules { lib = nixpkgs.lib; });
      nixosProfiles = import ./profiles;

      nixosConfigurations = {
        celebi = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = globalModules ++ [
              ./hosts/celebi/configuration.nix

              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel

              {
                home-manager.users.vitalya.imports = [
                  ./hosts/celebi/home.nix
                ];
              }
            ];
          };
        shinx = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = globalModules ++ [
              ./hosts/shinx/configuration.nix

              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd

              {
                home-manager.users.vitalya.imports = [
                  ./hosts/shinx/home.nix
                ];
              }
            ];
          };
        porygon = nixpkgs.lib.nixosSystem
          {
            system = "aarch64-linux";
            specialArgs = { inherit inputs; };
            modules = globalModules ++ [
              ./hosts/porygon/configuration.nix

              {
                home-manager.users.vitalya.imports = [
                  ./hosts/porygon/home.nix
                ];
              }
            ];
          };
      };

      darwinConfigurations."applin" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/applin/configuration.nix
        ];
      };
    };

  nixConfig = {
    trusted-users = [ "root" "vitalya" ];
  };
}
