{ ... }:

{
  den.aspects.forgejo-runner.nixos = { config, ... }: {
    age.secrets.forgejo-runner-token.file = ../../secrets/forgejo-runner-token.age;

    # Host must set: settings.server.connections.default.{url,uuid}
    services.forgejo-runner.instances.default = {
      enable = true;
      settings.runner.labels = [
        "ubuntu-latest:docker://node:current"
      ];
      secrets.server.connections.default.token_url = config.age.secrets.forgejo-runner-token.path;
    };
  };
}
