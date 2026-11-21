{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.chatgpt-desktop = mkApp {
    darwinCasks = [ "chatgpt" ];
    nixosHomePackages = pkgs: [ pkgs.chatgpt ];
  };
}
