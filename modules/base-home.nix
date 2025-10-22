{ pkgs, ... }:

{
  home-manager.users.vitalya = {
    home.packages = with pkgs; [
      # system utilities
      nixpkgs-fmt
      p7zip
      neofetch
      file
      htop
      ranger

      # ranger preview utilities
      atool
      unzip
      poppler_utils

      # dev tools
      nodejs_latest
      yarn
      bun
      httpie
    ];

    # nixpkgs.config.allowUnfreePredicate = (pkg: true);

    manual.manpages.enable = false;

    programs = {
      ranger = {
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
        };
        settings = {
          user.name = "Vitaliy Volynskiy";
          user.email = "i@vitalya.me";
          credential.helper = "store";
          push.followTags = true;
          init.defaultBranch = "main";
        };
      };
    };
  };
}
