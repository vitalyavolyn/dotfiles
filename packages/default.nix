{ inputs, ... }:

{
  perSystem = { pkgs, system, ... }:
    let
      rustPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ (import inputs.rust-overlay) ];
        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };
      };
    in
    {
      packages = {
        paperless-concierge = pkgs.callPackage ./paperless-concierge.nix { };
      } // pkgs.lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
        shrimply = rustPkgs.callPackage ./shrimply.nix { };
      } // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        work-cal-export = pkgs.callPackage ./work-cal-export { };
      };
    };
}
