{ config, lib, pkgs, ... }:

let
  inherit (import ../../lib { inherit lib; }) homelab;
  developmentDatabase = "dev";
in
{
  services.postgresql = {
    ensureDatabases = [ developmentDatabase ];
    ensureUsers = [{
      name = developmentDatabase;
      ensureDBOwnership = true;
    }];
    settings.listen_addresses = lib.mkForce
      "localhost,${homelab.nodes.shinx.tailnetIp}";
    authentication = lib.mkAfter ''
      host ${developmentDatabase} ${developmentDatabase} ${homelab.nodes.applin.tailnetIp}/32 trust
    '';
  };

  systemd.services.postgres-wait = {
    description = "Wait for Tailscale before PostgreSQL";
    after = [ "tailscaled.service" "tailscaled-autoconnect.service" ];
    wants = [ "tailscaled.service" ];
    path = [ config.services.tailscale.package pkgs.jq ];
    serviceConfig = {
      Type = "oneshot";
      User = "vitalya";
      RemainAfterExit = true;
    };
    enableStrictShellChecks = true;
    script = ''
      until tailscale status --json 2>/dev/null | jq -e '.BackendState == "Running"' >/dev/null; do
        echo "Waiting for Tailscale to become usable before PostgreSQL..."
        sleep 2
      done
    '';
  };

  systemd.services.postgresql = {
    after = [ "postgres-wait.service" ];
    wants = [ "postgres-wait.service" ];
  };

  services.redis.servers.dev = {
    enable = true;
    bind = homelab.nodes.shinx.tailnetIp;
    port = 6380;
    unixSocket = null;
    databases = 1;
    appendOnly = false;
    save = [ ];
    settings = {
      maxmemory = "128mb";
      maxmemory-policy = "allkeys-lru";
      protected-mode = "no";
    };
  };

  systemd.services.redis-dev.serviceConfig = {
    IPAddressDeny = "any";
    IPAddressAllow = [ homelab.nodes.applin.tailnetIp ];
  };
}
