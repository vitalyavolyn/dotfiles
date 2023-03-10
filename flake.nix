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
      stateVersion = "20.09";
    in
    {
      nixosConfigurations = {
        celebi = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              { system = { inherit stateVersion; }; }

              hyprland.nixosModules.default
              { programs.hyprland.enable = true; }

              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
              nixos-hardware.nixosModules.common-cpu-intel

              home-manager.nixosModules.home-manager
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
                      { wayland.windowManager.hyprland.enable = true; }
                      ./home/home.nix
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
