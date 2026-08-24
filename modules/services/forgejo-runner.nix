{ ... }:

{
  den.aspects.forgejo-runner.nixos = { config, lib, ... }: {
    age.secrets.forgejo-runner-token.file = lib.mkDefault ../../secrets/forgejo-runner-token.age;

    # Host must set: settings.server.connections.default.{url,uuid}
    services.forgejo-runner.instances.default = {
      enable = true;
      settings.runner.labels = lib.mkDefault [
        "ubuntu-latest:docker://node:current"
      ];
      secrets.server.connections.default.token_url = config.age.secrets.forgejo-runner-token.path;
    };
  };
}
