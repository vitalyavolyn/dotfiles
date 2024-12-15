{ pkgs, lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    } // (if pkgs.stdenv.isLinux then {
      dates = "weekly";
    } else {
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
    });
    settings = {
      trusted-users = [ "root" "vitalya" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;
}
