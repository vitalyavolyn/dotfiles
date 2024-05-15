{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  home = {
    stateVersion = "20.09";

    packages = with pkgs; [
      # system utilities
      pavucontrol
      gparted
      steam-run
      vlc

      # ranger preview utilities
      atool
      unzip
      poppler_utils

      # internet stuff
      google-chrome
      # webcord
      (discord.override {
        withOpenASAR = true;
      })
      tdesktop
      qbittorrent
      dnsutils

      # laptop stuff
      acpi
      acpilight

      # dev tools
      dbeaver
      gnumake
      robo3t
      mongodb-compass
      insomnia
      nixd

      # launching ncalayer
      xorg.xmessage
      nssTools
      libnotify

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

    spicetify = {
      enable = true;
      theme = spicePkgs.themes.Default;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [ popupLyrics ];
    };
  };
}
