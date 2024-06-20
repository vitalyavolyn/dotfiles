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
      httpie
    ];

    nixpkgs.config.allowUnfreePredicate = (pkg: true);

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
        userName = "Vitaliy Volynskiy";
        userEmail = "i@vitalya.me";
        signing = {
          key = "C5FD1B39EB6F5BFE";
          signByDefault = true;
        };
        extraConfig = {
          credential.helper = "store";
          push.followTags = true;
          init.defaultBranch = "main";
        };
      };
    };
  };
}
