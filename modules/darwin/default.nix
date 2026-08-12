{ lib, ... }:

{
  den.aspects.darwin = {
    darwin = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.nh ];

      security.pam.services.sudo_local.touchIdAuth = true;
      system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
    };

    homeManager.programs.zsh.shellAliases.nbs = lib.mkForce "nh darwin switch";
  };
}
