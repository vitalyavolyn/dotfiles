{ pkgs, lib, inputs, stateVersion, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  hyprlandContribPkgs = inputs.hyprland-contrib.packages.${pkgs.system};
in
{
  imports = [ ./vscode.nix ];

  home = {
    inherit stateVersion;

    packages = with pkgs; [
      # system utilities
      pfetch
      nixpkgs-fmt
      p7zip
      pavucontrol
      paper-icon-theme
      neofetch
      gparted
      steam-run
      vlc
      file
      tofi
      waybar # TODO: can be configured with home-manager
      hyprlandContribPkgs.grimblast
      grim
      slurp
      playerctl
      # keybase
      swaylock-effects
      swayidle # TODO: can be configured with home-manager
      htop

      # file manager and its preview utilities
      ranger
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

      # dev stuff
      nodejs_latest
      yarn
      dbeaver
      gnumake
      robo3t
      mongodb-compass
      docker-compose
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
      "bin".source = ./bin;

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
    "hypr/hyprland.conf".source = ./configs/hyprland.conf;
    "waybar".source = ./configs/waybar;
    "tofi/config".source = ./configs/tofi.ini;
    "swaylock/config".source = ./configs/swaylock;
  };

  programs = {
    go = {
      enable = true;
      goPath = "go";
    };

    kitty = {
      enable = true;
      font.name = "Fira Code";
      theme = "Afterglow";
      settings = {
        confirm_os_window_close = 0;
      };
      shellIntegration.enableZshIntegration = true;
    };

    spicetify = {
      enable = true;
      theme = spicePkgs.themes.Default;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [ popupLyrics ];
    };
  };

  services = {
    dunst.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  # produces a warning? is this necessary?
  wayland.windowManager.hyprland.enable = true;
}
