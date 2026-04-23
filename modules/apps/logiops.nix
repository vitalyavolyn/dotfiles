{ pkgs, ... }:

let
  config = pkgs.writeText "logid.cfg" ''
    io_timeout: 60000.0;
    workers: 16;

    devices: ({
        name: "MX Master 3S";

        thumbwheel: {
          divert: true;
          invert: false;
          left: {
            mode: "OnInterval";
            interval: 1;
            action: { type: "Keypress"; keys: ["KEY_VOLUMEDOWN"]; };
          };
          right: {
            mode: "OnInterval";
            interval: 1;
            action: { type: "Keypress"; keys: ["KEY_VOLUMEUP"]; };
          };
        };

        buttons: ({
          # Gesture button (large thumb button)
          cid: 0xc3;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "Left";
                mode: "OnRelease";
                action: { type: "Keypress"; keys: ["KEY_LEFTMETA", "KEY_PAGEDOWN"]; };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: { type: "Keypress"; keys: ["KEY_LEFTMETA", "KEY_PAGEUP"]; };
              }
            );
          };
        });
      });
  '';
in
{
  environment.systemPackages = [ pkgs.logiops ];

  systemd.services.logid = {
    description = "Logitech HID++ daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.logiops}/bin/logid -c ${config}";
      Restart = "on-failure";
    };
  };
}
