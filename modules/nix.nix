{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    # a fucked up way to check if this is macOS
    (if (builtins.hasAttr "homebrew" options) then {
      nix.gc.automatic = true;
      nix.gc.interval = { Weekday = 0; Hour = 0; Minute = 0; };
    } else {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 3";
      };

      nix.gc.automatic = false;
      nix.gc.dates = "weekly";
    })

    {
      nix = {
        gc = {
          options = "--delete-older-than 7d";
        };
        settings = {
          trusted-users = [ "root" "vitalya" ];
          experimental-features = [ "nix-command" "flakes" ];
        };
        optimise.automatic = true;
      };

      nixpkgs.config.allowUnfreePredicate = (pkg: true);
      nixpkgs.config.allowUnfree = true;
      # todo: sonarr
      # https://github.com/NixOS/nixpkgs/issues/360592
      nixpkgs.config.permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
        "aspnetcore-runtime-6.0.36"
      ];
    }
  ];
}
