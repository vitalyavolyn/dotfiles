{ pkgs, ... }:

{
  nix.settings.trusted-users = [ "vitalya" ];

  users = {
    # DON'T set mutableUsers to false

    users.vitalya = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJOIQWALhrUwF6a23G9g3i/LjI50Bl/PGO1RauHJBks vitalya@celebi"
      ];
    } // (if pkgs.stdenv.isLinux then {
      extraGroups = [ "wheel" "networkmanager" "docker" "video" "input" "audio" ];
      isNormalUser = true;
      createHome = true;
    } else { });
  };

  security.sudo =
    if pkgs.stdenv.isLinux then {
      wheelNeedsPassword = false;
    } else { };
}
