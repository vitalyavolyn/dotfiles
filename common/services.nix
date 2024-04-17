{ pkgs, ... }:

{
  services = {
    openssh.enable = true;

    tailscale.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      # openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
      extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };
}
