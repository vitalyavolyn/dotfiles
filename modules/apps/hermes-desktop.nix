{ inputs, ... }:

{
  den.aspects.hermes-desktop.homeManager = { config, lib, ... }:
    let
      inherit (import ../../lib { inherit lib; }) homelab;
    in
    {
      imports = [ inputs.hermes-agent.homeManagerModules.default ];

      programs.hermes-agent.desktop = {
        enable = true;
        # No local services.hermes-agent here — the app talks to the
        # gateway already running on shinx instead of starting its own.
        # Sign-in happens once via the app's own Settings -> Gateway ->
        # Remote gateway -> Basic Auth, using the hermes-dashboard-auth
        # secret's credentials.
        package = config.programs.hermes-agent.package.hermesDesktop.override {
          extraEnv.HERMES_DESKTOP_REMOTE_URL = "https://${homelab.domainFor "hermes"}";
        };
      };
    };
}
