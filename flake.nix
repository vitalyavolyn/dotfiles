{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    paperwm-spoon = {
      url = "github:mogenson/PaperWM.spoon";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nix-darwin, nix-homebrew, agenix, nix-index-database, ... } @ inputs:
    let
      globalModules = [
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
              home-manager.nixosModules.home-manager
              ./hosts/celebi/configuration.nix

              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel

              nix-index-database.nixosModules.nix-index

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
              home-manager.nixosModules.home-manager
              ./hosts/shinx/configuration.nix

              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd

              nix-index-database.nixosModules.nix-index

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
              home-manager.nixosModules.home-manager
              ./hosts/porygon/configuration.nix

              nix-index-database.nixosModules.nix-index

              {
                home-manager.users.vitalya.imports = [
                  ./hosts/porygon/home.nix
                ];
              }
            ];
          };
      };

      darwinConfigurations."applin" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = globalModules ++ [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager

          nix-index-database.darwinModules.nix-index

          ./hosts/applin/configuration.nix
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };

  nixConfig = {
    trusted-users = [ "root" "vitalya" ];
  };
}
