{ pkgs, ... }:

{
  nix = {
    gc = {
      automatic = false; # see nh
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
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
}
