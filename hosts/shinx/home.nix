{ pkgs, lib, inputs, stateVersion, ... }:

{
  home = {
    inherit stateVersion;

    packages = with pkgs; [
      # system utilities
      pfetch
      p7zip
      neofetch
      file
      htop
      ranger
      nodejs_latest
      yarn
      docker-compose
    ];

    file = {
      # TODO: common
      ".gitconfig".source = ../celebi/home/configs/gitconfig;
    };
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs = {
    # TODO: COMMON
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

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  manual.manpages.enable = false;
}
