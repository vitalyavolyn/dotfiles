{ ... }:

{
  den.aspects.vitalya = { user, ... }: {
    # The user class is forwarded to users.users.${user.userName} on every host.
    user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJOIQWALhrUwF6a23G9g3i/LjI50Bl/PGO1RauHJBks vitalya@celebi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHxLEltEiXjU8yHEE2R9T72mWOA1QmIf4zvqzTzO5PW hermes-agent@shinx"
    ];

    os.nix.settings.trusted-users = [ user.userName ];

    nixos = {
      users.users.${user.userName} = {
        # wheel/networkmanager come from Den's primary-user battery.
        extraGroups = [ "docker" "video" "input" "audio" ];
        createHome = true;
      };

      security.sudo.wheelNeedsPassword = false;
    };
  };
}
