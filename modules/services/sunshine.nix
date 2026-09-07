{ inputs, ... }:

{
  den.aspects.sunshine.nixos =
    { config, pkgs, ... }:
    let
      displayconfigMutter = inputs.displayconfig-mutter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      displayState = "$XDG_RUNTIME_DIR/sunshine-display-config";

      sunshineDisplayStart = pkgs.writeShellScript "sunshine-display-start" ''
        set -euo pipefail

        connector="$(${displayconfigMutter}/bin/displayconfig-mutter list \
          | ${pkgs.gawk}/bin/awk -F '│' '
              NR > 2 {
                connector = $2
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", connector)
                if (connector ~ /^(HDMI|DP)-/) { print connector; found = 1; exit }
                if (connector ~ /^eDP-/) fallback = connector
              }
              END { if (!found && fallback) print fallback }
            ')"

        if [ -z "$connector" ]; then
          echo "No active display connector found" >&2
          exit 1
        fi

        ${displayconfigMutter}/bin/displayconfig-mutter save-file "${displayState}"
        echo "Changing $connector to ''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT} at ''${SUNSHINE_CLIENT_FPS} Hz"
        if ! ${displayconfigMutter}/bin/displayconfig-mutter set \
          --connector "$connector" \
          --resolution "''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}" \
          --refresh-rate "''${SUNSHINE_CLIENT_FPS}"; then
          echo "Requested mode is unsupported; falling back to 1280x720" >&2
          if ! ${displayconfigMutter}/bin/displayconfig-mutter set \
            --connector "$connector" \
            --resolution 1280x720 \
            --refresh-rate "''${SUNSHINE_CLIENT_FPS}"; then
            echo "Fallback mode also failed; keeping the current display mode" >&2
            ${pkgs.coreutils}/bin/rm -f "${displayState}"
          fi
        fi
      '';

      sunshineDisplayStop = pkgs.writeShellScript "sunshine-display-stop" ''
        set -euo pipefail

        if [ -f "${displayState}" ]; then
          ${displayconfigMutter}/bin/displayconfig-mutter load-file "${displayState}"
          ${pkgs.coreutils}/bin/rm -f "${displayState}"
        fi
      '';

      displayPrep = [
        {
          do = "${sunshineDisplayStart}";
          undo = "${sunshineDisplayStop}";
        }
      ];

      sunshineSteam = pkgs.writeShellScript "sunshine-steam" ''
        cd "$HOME"
        exec ${config.programs.steam.package}/bin/steam "$@"
      '';
    in
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        # openFirewall = true;

        applications = {
          apps = [
            {
              name = "Desktop";
              image-path = "desktop.png";
              prep-cmd = displayPrep;
            }
            {
              name = "Steam Big Picture";
              detached = [
                "${sunshineSteam} steam://open/bigpicture"
              ];
              prep-cmd = displayPrep ++ [
                {
                  do = "";
                  undo = "${sunshineSteam} steam://close/bigpicture";
                }
              ];
              image-path = "steam.png";
            }
          ];
        };
      };

      # Application undo commands are skipped if Sunshine crashes mid-stream.
      systemd.user.services.sunshine.serviceConfig.ExecStopPost = sunshineDisplayStop;
    };
}
