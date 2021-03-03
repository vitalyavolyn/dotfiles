{ pkgs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    kitty
  ];
  environment.variables.TERMINAL = "kitty";

  programs.zsh.enable = true;
  programs.steam.enable = true; # TODO: don't make this system-wide?

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
}
