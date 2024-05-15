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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, spicetify-nix, hyprland, ... } @ inputs:
    let
      globalModules = [
        home-manager.nixosModules.home-manager

        ./common

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
                  spicetify-nix.homeManagerModule
                  hyprland.homeManagerModules.default

                  ./common/home
                  ./hosts/celebi/home/home.nix
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
                  ./common/home
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
                  ./common/home
                  ./hosts/porygon/home.nix
                ];
              }
            ];
          };
      };
    };

  nixConfig = {
    extra-trusted-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    trusted-users = [ "root" "vitalya" ];
  };
}
