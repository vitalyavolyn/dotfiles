{ pkgs, lib, inputs, stateVersion, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  hyprlandContribPkgs = inputs.hyprland-contrib.packages.${pkgs.system};
in
{
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
      etcher
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
      # jetbrains.webstorm
      # jetbrains.datagrip
      dbeaver
      gnumake
      # robo3t
      docker-compose
      insomnia
      wakatime
      # android-tools
      # scrcpy # broken on wayland

      # launching ncalayer
      xorg.xmessage
      nssTools
      libnotify

      # lifestyle & fun
      # obsidian
      krita
      obs-studio

      # games?
      # minecraft
      prismlauncher
      # mgba
      # dolphin-emu
    ];

    file = {
      "bin".source = ./bin;

      ".ssh/config".source = ./configs/ssh-config;
      ".gitconfig".source = ./configs/gitconfig;
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
    "Code/User/settings.json".source = ./configs/vscode.json;
    "i3/config".source = ./configs/i3-config;
    "ranger/rc.conf".source = ./configs/ranger.conf;
    "hypr/hyprland.conf".source = ./configs/hyprland.conf;
    "waybar".source = ./configs/waybar;
    "tofi/config".source = ./configs/tofi.ini;
    "swaylock/config".source = ./configs/swaylock;
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs = {
    # TODO: split this into separate files?
    zsh = {
      enable = true;

      autocd = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      history = {
        ignoreDups = true;
      };

      shellAliases = {
        l = "ls";
        la = "ls -a";
        x = "xclip -sel clip";
        nbs = "time sudo nixos-rebuild switch";
        nbsu = "time sudo nixos-rebuild switch --upgrade";
      };

      # TODO: how to make REPORTTIME work?
      localVariables = {
        PATH = "$PATH:$HOME/bin:$HOME/.pub-cache/bin:$HOME/.yarn/bin";
        EDITOR = "vim";
      };

      plugins = with pkgs; [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];

      oh-my-zsh = {
        enable = true;

        plugins = [ "git" "sudo" "dotenv" "yarn" "docker-compose" "history" ];
        theme = "fishy";
      };
    };

    go = {
      enable = true;
      goPath = "go";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
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

    vscode = with pkgs; {
      enable = true;
      package = vscode;
      extensions = with vscode-extensions; [
        jnoortheen.nix-ide
        eamodio.gitlens
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.2.3";
          sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
        }
      ];
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

  manual.manpages.enable = false;
}
