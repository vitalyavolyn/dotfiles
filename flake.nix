{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = github:the-argus/spicetify-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, spicetify-nix, hyprland, ... } @ inputs:
    let
      system = "x86_64-linux";
      stateVersion = "20.09";
      globalModules = [
        home-manager.nixosModules.home-manager

        ./common/users.nix
        ./common/nix.nix
        ./common/general.nix
        ./common/packages.nix
        ./common/services.nix
      ];
    in
    {
      nixosConfigurations = {
        celebi = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = globalModules ++ [
              ./hosts/celebi/configuration.nix

              { system = { inherit stateVersion; }; }

              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs stateVersion;
                  };
                  users.vitalya = {
                    imports = [
                      spicetify-nix.homeManagerModule
                      hyprland.homeManagerModules.default
                      ./common/home/zsh.nix
                      ./hosts/celebi/home/home.nix
                    ];
                  };
                };
              }
            ];
          };
        shinx = nixpkgs.lib.nixosSystem
          {
            specialArgs = { inherit inputs; };
            modules = globalModules ++ [
              ./hosts/shinx/configuration.nix

              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    # stateversion is wrong
                    inherit inputs stateVersion;
                  };
                  users.vitalya = {
                    imports = [
                      ./common/home/zsh.nix
                      ./hosts/shinx/home.nix
                    ];
                  };
                };
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
