{ pkgs, ... }:

{
  home = {
    stateVersion = "20.09";

    packages = with pkgs; [
      # system utilities
      steam-run
      pavucontrol
    ];

    file = {
      ".ssh/config".source = ./configs/ssh-config;
    };
  };

  xdg.configFile = {
    "nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
