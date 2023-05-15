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

    # github-copilot-intellij-agent-nixpkgs.url = "github:hacker1024/nixpkgs/090b58d7cd7450e3a29bf7baed7f3cd6f32cd8d6";
    idea-plugins-nixpkgs.url = "github:GenericNerdyUsername/nixpkgs/b263fdc5941d621308a9953d5ca1c163dce5209f";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, spicetify-nix, hyprland, idea-plugins-nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      stateVersion = "20.09";
      idea-plugins = import idea-plugins-nixpkgs {
        inherit system;
        config.allowUnfree = true; 
      };
    in
    {
      nixosConfigurations = {
        celebi = nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              ./configuration.nix
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
                    inherit inputs stateVersion idea-plugins;
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
