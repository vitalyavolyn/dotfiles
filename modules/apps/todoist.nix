{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.todoist = mkApp {
    darwinCasks = [ "todoist" ];
    home = { pkgs, ... }: {
      home.packages = [ pkgs.todoist-cli ];
    };
    nixosHomePackages = pkgs: [ pkgs.todoist-electron ];
  };
}
