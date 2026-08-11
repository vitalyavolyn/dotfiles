{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.firefox = mkApp {
    darwinCasks = [ "firefox" ];
    nixosHome = { pkgs, ... }: {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        configPath = ".mozilla/firefox";
      };
    };
  };
}
