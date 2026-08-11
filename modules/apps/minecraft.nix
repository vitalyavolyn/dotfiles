{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.minecraft = mkApp {
    darwinCasks = [ "prismlauncher" ];
    nixosHomePackages = pkgs: [ pkgs.prismlauncher ];
  };
}
