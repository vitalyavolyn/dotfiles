{ pkgs, ... }:

{
  home-manager.users.vitalya.programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };
}
