{ lib, ... }:

{
  den.aspects.darwin = {
    darwin = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.nh ];

      security.pam.services.sudo_local.touchIdAuth = true;
      system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
    };

    # TODO: WHY do i need bew upgrade??? i can't just add --greedy to brew args, it errors out.
    # this command is also interactive!!!!!!!!
    homeManager.programs.zsh.shellAliases.nbs = lib.mkForce "nh darwin switch && brew upgrade -g";
  };
}
