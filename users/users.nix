{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.vitalya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  home-manager.users.vitalya = {
    home.packages = with pkgs; [
      neofetch
      nixpkgs-fmt
      google-chrome
      discord
      vk-messenger
      tdesktop
      p7zip
      xsel
      pavucontrol
      ranger
      xfce.thunar
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
    };

    programs = {
      zsh = {
        enable = true;

        autocd = true;
        enableAutosuggestions = true;

        # TODO: how to make REPORTTIME work?

        history = {
          ignoreDups = true;
        };

        shellAliases = {
          l = "ls";
          la = "ls -a";
          x = "xclip -sel clip";
        };

        localVariables = {
          REPORTTIME = 10;
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
              rev = "v0.1.0";
              sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
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

    gtk = {
      enable = true;
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  security.sudo.wheelNeedsPassword = false;
}
