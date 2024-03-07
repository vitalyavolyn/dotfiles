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
    in
    {
      nixosConfigurations = {
        celebi = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/celebi/configuration.nix
              { system = { inherit stateVersion; }; }

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
                      # TODO: why is this here
                      { wayland.windowManager.hyprland.enable = true; }
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
            modules = [
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd
              ./hosts/shinx/configuration.nix
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
