{ ... }:

{
  den.aspects.docker = {
    nixos = {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
        autoPrune.enable = true;
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        docker-compose
      ];
    };
  };
}
