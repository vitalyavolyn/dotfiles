{ ... }:

let
  common = {
    nix = {
      gc.options = "--delete-older-than 7d";
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
      optimise.automatic = true;
    };

    nixpkgs.config.allowUnfreePredicate = pkg: true;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.nvidia.acceptLicense = true;

    # TODO: shadowsocks 🙄
    nixpkgs.config.permittedInsecurePackages = [
      "mbedtls-2.28.10"
    ];
  };
in
{
  den.aspects.nix = {
    os = common;

    nixos = {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 3";
      };

      nix.gc = {
        automatic = false;
        dates = "weekly";
      };
    };

    darwin = {
      nix.gc = {
        automatic = true;
        interval = {
          Weekday = 0;
          Hour = 0;
          Minute = 0;
        };
      };
    };
  };
}
