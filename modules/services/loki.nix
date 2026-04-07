{ ... }:

{
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false; # behind tailscale

      server = {
        http_listen_port = 3100;
        http_listen_address = "0.0.0.0";
      };

      common = {
        path_prefix = "/var/lib/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
      };

      schema_config.configs = [{
        from = "2024-01-01";
        store = "tsdb";
        object_store = "filesystem";
        schema = "v13";
        index = { prefix = "index_"; period = "24h"; };
      }];

      limits_config = {
        retention_period = "720h"; # 30 days
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      compactor = {
        working_directory = "/var/lib/loki/compactor";
        compaction_interval = "10m";
        retention_enabled = true;
        retention_delete_delay = "2h";
        delete_request_store = "filesystem";
      };
    };
  };

  # Only reachable from within the tailnet
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3100 ];
}
