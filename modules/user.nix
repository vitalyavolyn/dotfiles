{ pkgs, ... }:

{
  nix.settings.trusted-users = [ "vitalya" ];

  users = {
    # mutableUsers = false;

    users.vitalya = {
      extraGroups = [ "wheel" "networkmanager" "docker" "video" "input" "audio" ];
      isNormalUser = true;
      createHome = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJOIQWALhrUwF6a23G9g3i/LjI50Bl/PGO1RauHJBks vitalya@celebi"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
