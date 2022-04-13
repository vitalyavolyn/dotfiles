{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.vitalya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager.users.vitalya = {
    home.packages = with pkgs; [
      # system utilities
      pfetch
      nixpkgs-fmt
      xsel
      p7zip
      pavucontrol
      ranger
      xfce.thunar
      maim
      paper-icon-theme
      wineWowPackages.stable
      winetricks
      neofetch
      gparted

      # internet stuff
      google-chrome
      discord
      vk-messenger
      tdesktop
      qbittorrent
      youtube-dl
      spotify

      # laptop stuff
      acpi
      acpilight

      # dev stuff
      nodejs_latest
      yarn
      jetbrains.webstorm
      gnumake

      # games?
      minecraft
      # osu-lazer

      # work
      notion-app-enhanced
      slack
      zoom-us
    ];

    home.file = {
      # TODO: add to PATH
      "bin".source = ./bin;

      ".ssh/config".source = ./configs/ssh-config;
      ".gitconfig".source = ./configs/gitconfig;
    };

    xdg.configFile = {
      "nixpkgs/config.nix".source = ../nixpkgs-config.nix;
      "Code/User/settings.json".source = ./configs/vscode.json;
      "i3/config".source = ./configs/i3-config;
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
        };

        # TODO: how to make REPORTTIME work?
        localVariables = {
          # TODO: $GOPATH/bin?
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
      };

      vscode = with pkgs; {
        enable = true;
        package = vscode;
        extensions = with vscode-extensions; [
          jnoortheen.nix-ide
          eamodio.gitlens
          ms-vscode-remote.remote-ssh
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [{
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.2.3";
          sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
        }];
      };
    };

    services = {
      picom.enable = true;
      network-manager-applet.enable = true;
      # polybar = {
      #   enable = true;
      #   package = pkgs.polybar.override {
      #     i3GapsSupport = true;
      #     pulseSupport = true;
      #     githubSupport = true; # what is this
      #   };
      #   script = "polybar example &";
      #   extraConfig = builtins.readFile ./configs/polybar-config;
      # };
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

    xsession = {
      numlock.enable = true;

      pointerCursor = {
        package = pkgs.paper-icon-theme;
        name = "Paper";
        size = 16;
      };
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  security.sudo.wheelNeedsPassword = false;
}
