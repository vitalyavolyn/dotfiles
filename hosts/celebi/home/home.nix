{ pkgs, ... }:

{
  home = {
    stateVersion = "20.09";

    packages = with pkgs; [
      # system utilities
      pavucontrol
      steam-run
      vlc

      # internet stuff
      google-chrome
      qbittorrent

      # dev tools
      dbeaver
      gnumake
      robo3t
      mongodb-compass
      insomnia
      nixd

      # lifestyle & fun
      krita
      obs-studio

      # games?
      prismlauncher

      # wtf minecraft requires this
      flite

      # work
      zoom-us
    ];

    file = {
      ".ssh/config".source = ./configs/ssh-config;
    };

    pointerCursor = {
      x11.enable = true;
      package = pkgs.paper-icon-theme;
      name = "Paper";
      size = 16;
    };
  };

  xdg.configFile = {
    "nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  };

  programs = {
    go = {
      enable = true;
      goPath = "go";
    };
  };
}
