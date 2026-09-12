{ ... }:

{
  perSystem = { pkgs, ... }:
    {
      packages = {
        paperless-concierge = pkgs.callPackage ./paperless-concierge.nix { };
      } // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        work-cal-export = pkgs.callPackage ./work-cal-export { };
      };
    };
}
