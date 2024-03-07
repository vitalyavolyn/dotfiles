{ pkgs, ... }:

{
  services = {
    openssh.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      # openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        hinfo = true;
      };
      extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
    };

    # this will soon be configurable on nixos-unstable
    homepage-dashboard = {
      enable = true;
    };

    jellyfin.enable = true;
    jackett.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    transmission = {
      enable = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
        incomplete-dir = "/mnt/media/downloads/incomplete";
        download-dir = "/mnt/media/downloads/complete";
      };
    };
  };
}
