{ den, ... }:

{
  den.hosts.aarch64-darwin.applin.users.vitalya = { };

  den.aspects.applin = {
    includes = with den.aspects; [
      base-darwin
      dev
      ghostty
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
      todoist
      work-cal-export
    ];

    darwin = {
      homebrew = {
        casks = [
          "microsoft-teams"
          "tunnelblick"
          "bitwarden"
          "cyberduck"
          # Prebuilt DMG instead of the Nix-built Electron app — the Nix
          # build pulls in hermes-agent's full ML dependency chain (torch,
          # onnxruntime, faster-whisper) with poor aarch64-darwin binary
          # cache coverage, so it builds most of it from source.
          "hermes-desktop"

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
