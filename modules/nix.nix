{ pkgs, ... }:

{
  nix = {
    gc = {
      automatic = if pkgs.stdenv.isLinux then false else true;
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

  programs =
    if pkgs.stdenv.isLinux then {
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 3";
      };
    } else { };

  # Auto upgrade nix package and the daemon service.
  services =
    if pkgs.stdenv.isDarwin then {
      nix-daemon.enable = true;
    } else { };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;
}
