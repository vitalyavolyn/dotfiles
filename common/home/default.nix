{ pkgs, version, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.file = {
    ".gitconfig".source = ./configs/gitconfig;
  };

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
  };
}