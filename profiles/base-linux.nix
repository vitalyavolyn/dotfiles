{ den, inputs, ... }:

{
  den.aspects.base-linux = {
    includes = with den.aspects; [
      base-home
      base-packages
      zsh
      boot
      locale
      nix
      ssh-server
      fail2ban
    ];

    nixos = { pkgs, ... }: {
      imports = with inputs; [
        nix-index-database.nixosModules.nix-index
        agenix.nixosModules.default
      ];

      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      environment.variables = {
        FLAKE = "/etc/nixos";
        NH_FLAKE = "/etc/nixos";
      };
    };
  };
}
