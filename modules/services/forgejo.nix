{ inputs, ... }:

{
  den.aspects.forgejo.nixos = { lib, config, pkgs, ... }: {
    # TODO: options?
    # Host must set: stateDir, settings.server.{DOMAIN,ROOT_URL,SSH_DOMAIN}
    services.forgejo = {
      enable = true;
      package = pkgs.forgejo;
      database.type = "postgres";
      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = inputs.self.lib.homelab.portFor "git";
          START_SSH_SERVER = false;
          SSH_PORT = lib.head config.services.openssh.ports;
        };
        service.DISABLE_REGISTRATION = true;
        actions = {
          ENABLED = true;
          # Bare `uses: owner/repo@ref` refs resolve against this. Forgejo defaults
          # to its own curated mirror (data.forgejo.org), which doesn't carry every
          # action (e.g. cachix/install-nix-action) — pull from GitHub directly instead.
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
  };
}
