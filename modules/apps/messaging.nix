{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.messaging = mkApp {
    darwinCasks = [ "discord" "telegram" ];
    nixosHomePackages = pkgs: with pkgs; [ discord telegram-desktop ];
  };
}
