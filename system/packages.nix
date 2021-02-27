{ pkgs, ... }:

{
  nixpkgs.config = import ./nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
  ];

  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
}
