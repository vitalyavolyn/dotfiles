{ ... }:

{
  den.schema.user.imports = [
    ({ lib, ... }: {
      options.baseHome.extras = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include optional home packages and programs.";
      };
    })
  ];

  den.aspects.base-home = { user, ... }: {
    homeManager = { pkgs, lib, ... }:
      let
        inherit (user.baseHome) extras;
      in
      {
        home.packages = with pkgs; [
          # system utilities
          p7zip
          file
          htop
          httpie
          (if extras then fastfetch else fastfetch-unwrapped)
        ] ++ lib.optionals extras [
          nixpkgs-fmt
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

        home.file.".vim/backup/.keep".text = "";
        home.file.".vim/swap/.keep".text = "";
        home.file.".vim/undo/.keep".text = "";

        # for personal scripts/binaries; already on PATH via zsh.nix
        home.file."bin/.keep".text = "";

        # nixpkgs.config.allowUnfreePredicate = (pkg: true);

        manual.manpages.enable = false;

        programs = {
          ranger = lib.mkIf extras {
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
  };
}
