{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.todoist = mkApp {
    darwinCasks = [ "todoist-app" ];
    home = { pkgs, ... }: {
      home.packages = [ pkgs.todoist-cli ];
    };
    nixosHomePackages = pkgs: [ pkgs.todoist-electron ];
  };
}
