{ pkgs, ... }:

{
  home = {
    stateVersion = "20.09";

    packages = with pkgs; [
    ];

    file = {
      ".ssh/config".source = ./configs/ssh-config;
    };
  };

  xdg.configFile = {
    "nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
