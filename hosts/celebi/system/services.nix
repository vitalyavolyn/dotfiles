{ ... }:

{
  # may fix long shutdown idk
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=10s
  '';
}
