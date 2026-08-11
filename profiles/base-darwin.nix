{ den, inputs, ... }:

{
  den.aspects.base-darwin = {
    includes = with den.aspects; [
      base-home
      base-packages
      zsh
      nix
      darwin
      brew
      fonts
    ];

    darwin = { pkgs, ... }: {
      imports = with inputs; [
        nix-homebrew.darwinModules.nix-homebrew
        nix-index-database.darwinModules.nix-index
        agenix.darwinModules.default
      ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      environment.variables = {
        FLAKE = "/Users/vitalya/dotfiles";
        NH_FLAKE = "/Users/vitalya/dotfiles";
      };
    };
  };
}
