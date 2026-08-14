{ den, ... }:

{
  den.hosts.aarch64-darwin.applin.users.vitalya = { };

  den.aspects.applin = {
    includes = with den.aspects; [
      base-darwin
      dev
      ollama
      tailscale
      vlc
      streaming
      minecraft
      messaging
      spotify
      krita
      obsidian
      claude-desktop
      chatgpt-desktop
      helium
      work-cal-export
    ];

    darwin = {
      homebrew = {
        casks = [
          "microsoft-teams"
          "tunnelblick"
          "ticktick"
          "bitwarden"
          "cyberduck"

          # TODO: cross platform logitech module
          "logi-options+"
        ];

        brews = [
          "mole"
        ];
      };

      system.stateVersion = 4;
    };

    homeManager = { pkgs, ... }: {
      home = {
        stateVersion = "24.05";
        packages = with pkgs; [
          jdk
          (python3.withPackages (p: [ p.numpy p.requests ]))
        ];
      };
    };
  };
}
