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
    # TODO: remove i3 stuff
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
      autosuggestion.enable = true;
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
      mutableExtensionsDir = false;

      userSettings = lib.importJSON ./configs/vscode/settings.json;
      keybindings = lib.importJSON ./configs/vscode/keybindings.json;

      extensions = with vscode-extensions; [
        jnoortheen.nix-ide

        eamodio.gitlens
        mhutchie.git-graph

        ms-vscode-remote.remote-ssh
        ms-azuretools.vscode-docker

        dbaeumer.vscode-eslint
        esbenp.prettier-vscode

        wmaurer.change-case
        redhat.vscode-yaml
        oderwat.indent-rainbow

        dart-code.flutter
        dart-code.dart-code

        ziglang.vscode-zig
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.3.0";
          sha256 = "sha256-8GGv4L4poTYjdkDwZxgNYajuEmIB5XF1mhJMxO2Ho84=";
        }
        {
          name = "supermaven";
          publisher = "supermaven";
          version = "0.1.40";
          sha256 = "sha256-BFm9H5dOSZ/V9Y/ZVap/XDDG/FDhHbi3p3ulqdDsMHc=";
        }
        {
          name = "bongocat-buddy";
          publisher = "JohnHarrison";
          version = "1.6.0";
          sha256 = "sha256-Oz7cmu3uY9De+EU3V/G59f2LeAOrwpwftxtIp/IPT3c=";
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
