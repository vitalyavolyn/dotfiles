{ config, pkgs, ... }:

{
  nix.trustedUsers = [ "vitalya" ];

  users.users.vitalya = {
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "input" ];
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC71Nu6rRV7ZHo9fS0B+Ny9bbSDVWqKU5034jwh1CZLAKzWaX3Ewj8Pb63HVN24Gt2qccKqhTEA2831UFSZX400X8PVTruItKboX81c7z4SKNUDClXkMMVt6Qw343p0viQSOdQmuX0ZPIg9x4wOO5aj5FFHBuolNlFLOFLFrl7gxpxj1H0B8/ERV1vInnJAtwr4pviruUygEmA9j5vWbIRvX1vHhJJ6fX93jBF6wMerfom4+dvicIoA17OKp/UbDcYjutx3eTWX2pXkmsPkLStIb/5RqVQ6wRdSbgVi0tZGP2WtU9kzEOITvi4rRPvgjm7gr5POyJmiVRHV/vSR5TiH vitalya@celebi"
    ];
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
