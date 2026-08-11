{ ... }:

{
  perSystem = { pkgs, ... }: {
    packages = {
      paperless-concierge = pkgs.callPackage ./paperless-concierge.nix { };
    } // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      work-cal-export = pkgs.callPackage ./work-cal-export { };
    };
  };
}
