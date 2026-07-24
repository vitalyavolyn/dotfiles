{ pkgs, ... }:

{
  services = {
    plex = { enable = true; group = "multimedia"; };
    jellyfin = { enable = true; group = "multimedia"; };
    radarr = { enable = true; group = "multimedia"; };
    sonarr = { enable = true; group = "multimedia"; };
    bazarr = { enable = true; group = "multimedia"; };
    prowlarr.enable = true;
    deluge = {
      enable = true;
      group = "multimedia";
      web.enable = true;
      declarative = true;
      # workaround for pkg_resources removal in setuptools 82 breaking deluge
      # https://github.com/NixOS/nixpkgs/issues/540545
      # TODO: remove once fixed upstream
      package = pkgs.deluge.overrideAttrs (old: {
        propagatedBuildInputs =
          pkgs.lib.remove pkgs.python3Packages.setuptools old.propagatedBuildInputs
          ++ [ pkgs.python3Packages.setuptools_80 ];
      });
      config = {
        enabled_plugins = [ "Label" ];
        random_port = false;
        listen_ports = [ 6881 6881 ];
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-auth";
        text = ''
          localclient::10
        '';
      };
    };
  };

  users.groups.multimedia = {
    members = [ "vitalya" ];
  };
}
