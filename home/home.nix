{ pkgs, lib, inputs, ... }:

let
  # TODO: figure out importing without "inputs"
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  jbToolboxPkgs = inputs.jetbrains-toolbox-nixpkgs.legacyPackages.${pkgs.system};
in
{
  home = {
    packages = with pkgs; [
      # system utilities
      pfetch
      nixpkgs-fmt
      xsel
      p7zip
      pavucontrol
      xfce.thunar
      maim
      paper-icon-theme
      neofetch
      gparted
      steam-run
      vlc
      file
      etcher
      wofi
      inputs.hyprland.packages.${pkgs.system}.waybar-hyprland
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

      ranger
      atool
      unzip
      poppler_utils

      # internet stuff
      google-chrome
      (discord.override {
        withOpenASAR = true;
      })
      vk-messenger
      tdesktop
      qbittorrent
      youtube-dl

      # laptop stuff
      acpi
      acpilight

      # dev stuff
      nodejs_latest
      yarn
      jetbrains.webstorm
      jetbrains.datagrip
      gnumake
      robo3t
      docker-compose
      postman
      zig
      zls
      wakatime
      jbToolboxPkgs.jetbrains-toolbox

      # work
      zoom-us

      # launching ncalayer
      xorg.xmessage nssTools libnotify jdk11

      # lifestyle & fun
      obsidian
      krita
      obs-studio

      # games?
      minecraft
      # osu-lazer
      # mgba
    ];

    file = {
      # TODO: add to PATH
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

    stateVersion = "20.09";
  };

  xdg.configFile = {
    "nixpkgs/config.nix".source = ../nixpkgs-config.nix;
    "Code/User/settings.json".source = ./configs/vscode.json;
    "i3/config".source = ./configs/i3-config;
    "ranger/rc.conf".source = ./configs/ranger.conf;
    "hypr/hyprland.conf".source = ./configs/hyprland.conf;
    "waybar".source = ./configs/waybar;
  };

  programs = {
    # TODO: split this into separate files?
    zsh = {
      enable = true;

      autocd = true;
      enableAutosuggestions = true;

      history = {
        ignoreDups = true;
      };

      shellAliases = {
        l = "ls";
        la = "ls -a";
        x = "xclip -sel clip";
        nbs = "time sudo nixos-rebuild switch";
        nbsu = "time sudo nixos-rebuild switch --upgrade";

        # for dumb zsh plugin
        wakatime = "wakatime-cli";
      };

      # TODO: how to make REPORTTIME work?
      localVariables = {
        # TODO: $GOPATH/bin?
        PATH = "$PATH:$HOME/bin:$HOME/.pub-cache/bin:$HOME/.yarn/bin";
        EDITOR = "vim";

        ZSH_WAKATIME_PROJECT_DETECTION = "true";
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
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
          };
        }
        {
          name = "zsh-wakatime";
          file = "zsh-wakatime.plugin.zsh";
          src = fetchFromGitHub {
            owner = "wbingli";
            repo = "zsh-wakatime";
            rev = "master";
            sha256 = "fJ4tdEkInlwv7F88QKg3pzYinxI3Ko7TbrJ32Kefud0=";
          };
        }
      ];

      oh-my-zsh = {
        enable = true;

        plugins = [ "git" "sudo" "dotenv" "yarn" ];
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
    };

    vscode = with pkgs; {
      enable = true;
      package = vscode;
      extensions = with vscode-extensions; [
        jnoortheen.nix-ide
        eamodio.gitlens
        ms-vscode-remote.remote-ssh
        WakaTime.vscode-wakatime
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.2.3";
          sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
        }
        {
          name = "zls-vscode";
          publisher = "AugusteRame";
          version = "1.0.4";
          sha256 = "Mb2RFRjD6+iw+ZaoMc/O3FU128bl9pGg07jPDDxrZtk=";
        }
        {
          name = "zig";
          publisher = "tiehuis";
          version = "0.2.5";
          sha256 = "P8Sep0OtdchTfnudxFNvIK+SW++TyibGVI9zd+B5tu4=";
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

  #services = {
    #picom = {
    #  enable = true;
    #  vSync = true;
    #};
    # network-manager-applet.enable = true;
  #};

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
