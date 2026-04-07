{ config, lib, pkgs, ... }:

let cfg = config.modules.alloy; in
{
  options.modules.alloy.lokiUrl = lib.mkOption {
    type = lib.types.str;
    description = "Full URL of the Loki push endpoint";
    example = "http://porygon.tail1234.ts.net:3100/loki/api/v1/push";
  };

  config = {
    services.alloy = {
      enable = true;
      configPath = pkgs.writeText "config.alloy" ''
        loki.source.journal "journal" {
          max_age    = "12h"
          forward_to = [loki.relabel.journal.receiver]
          labels = {
            job  = "systemd-journal",
            host = "${config.networking.hostName}",
          }
        }

        loki.relabel "journal" {
          forward_to = [loki.write.default.receiver]

          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }
          rule {
            source_labels = ["__journal_priority_keyword"]
            target_label  = "level"
          }
          // Podman/Docker container name — populated for oci-container units
          rule {
            source_labels = ["__journal__container_name"]
            target_label  = "container"
          }
        }

        loki.write "default" {
          endpoint {
            url = "${cfg.lokiUrl}"
          }
        }
      '';
    };

    # Alloy needs journal access
    systemd.services.alloy.serviceConfig.SupplementaryGroups = [ "systemd-journal" ];
  };
}
