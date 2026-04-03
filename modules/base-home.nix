{ pkgs, lib, config, ... }:

{
  options.modules.base-home.extras = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to include some extras.";
  };

  config.home-manager.users.vitalya = {
    home.packages = with pkgs; [
      # system utilities
      p7zip
      fastfetch
      file
      htop
      httpie
    ] ++ lib.optionals config.modules.base-home.extras [
      nixpkgs-fmt
      ranger
      speedtest-cli

      # ranger preview utilities
      atool
      unzip
      poppler-utils

      # dev tools
      nodejs_latest
      yarn-berry
      bun
    ];

    # TODO: move to vim module? use neovim???
    home.file.".vimrc".text = ''
      set smartindent
      set autoindent
      set number

      set backupdir=~/.vim/backup//
      set directory=~/.vim/swap//
      set undodir=~/.vim/undo//
    '';

    home.file.".vim/backup/.keep" = {
      text = "";
      recursive = true;
    };
    home.file.".vim/swap/.keep" = {
      text = "";
      recursive = true;
    };
    home.file.".vim/undo/.keep" = {
      text = "";
      recursive = true;
    };

    # nixpkgs.config.allowUnfreePredicate = (pkg: true);

    manual.manpages.enable = false;

    programs = {
      ranger = lib.mkIf config.modules.base-home.extras {
        enable = true;
        settings = {
          preview_images = true;
          preview_images_method = "kitty";
        };
      };

      git = {
        enable = true;
        signing = {
          key = "C5FD1B39EB6F5BFE";
          signByDefault = true;
          format = "openpgp";
        };
        settings = {
          user.name = "Vitaliy Volynskiy";
          user.email = "i@vitalya.me";
          credential.helper = "store";
          push.followTags = true;
          push.autoSetupRemote = true;
          init.defaultBranch = "main";
        };
      };
    };
  };
}
