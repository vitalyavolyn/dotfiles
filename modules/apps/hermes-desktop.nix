{ inputs, ... }:

{
  den.aspects.hermes-desktop = {
    nixos = { ... }: {
      age.secrets.hermes-desktop-token = {
        file = ../../secrets/hermes-desktop-token.age;
        owner = "vitalya";
      };
    };

    darwin = { ... }: {
      age.secrets.hermes-desktop-token = {
        file = ../../secrets/hermes-desktop-token.age;
        owner = "vitalya";
      };
    };

    homeManager = { config, lib, osConfig, ... }:
      let
        inherit (import ../../lib { inherit lib; }) homelab;
      in
      {
        imports = [ inputs.hermes-agent.homeManagerModules.default ];

        programs.hermes-agent.desktop = {
          enable = true;
          # No local services.hermes-agent here — the app talks to the
          # gateway already running on shinx instead of starting its own.
          package = config.programs.hermes-agent.package.hermesDesktop.override {
            extraEnv.HERMES_DESKTOP_REMOTE_URL = "https://${homelab.domainFor "hermes"}";
            extraRun = [
              ''
                token_file=${lib.escapeShellArg osConfig.age.secrets.hermes-desktop-token.path}
                if [ -r "$token_file" ]; then
                  HERMES_DESKTOP_REMOTE_TOKEN="$(tr -d '\r\n' < "$token_file")"
                  export HERMES_DESKTOP_REMOTE_TOKEN
                else
                  echo "hermes-desktop: cannot read the session token at $token_file." >&2
                fi
              ''
            ];
          };
        };
      };
  };
}
