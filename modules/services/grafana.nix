{ ... }:

{
  # Host must set: settings.server.{domain,root_url}
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3001;
      };
      analytics.reporting_enabled = false;
      # it's behind tailscale
      security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      "auth.anonymous" = {
        enabled = true;
        org_role = "Admin";
      };
    };

    provision.datasources.settings.datasources = [{
      name = "Loki";
      type = "loki";
      access = "proxy";
      url = "http://127.0.0.1:3100";
      isDefault = true;
    }];
  };
}
