{ den, ... }:

{
  den.aspects.gnome = { host, ... }: {
    includes = with den.aspects; [
      dconf
      gtk
    ];

    nixos =
      { lib, pkgs, ... }:
      let
        hasAspect = aspect: host.hasAspect aspect;
      in
      {
        services.xserver.enable = true;
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

        environment.systemPackages = with pkgs; [
          gnome-tweaks
        ] ++ (with pkgs.gnomeExtensions; [
          appindicator
          screen-rotate
          wiggle
          bluetooth-battery-meter
          search-light
          window-is-ready-remover
          pip-on-top
        ]) ++ lib.optionals (hasAspect den.aspects.tailscale) [
          pkgs.gnomeExtensions.tailscale-qs
        ];

        services.udev.packages = with pkgs; [
          gnome-settings-daemon
        ];

        environment.gnome.excludePackages = with pkgs; [
          gnome-tour
          gnome-terminal
          epiphany
          evince
          gnome-connections
          gnome-music
        ];
      };

    # Disable the screenshot sound by replacing it with a silent OGG file.
    homeManager = { pkgs, ... }: {
      xdg.dataFile."sounds/freedesktop/stereo/screen-capture.oga".source =
        pkgs.runCommand "silent.oga" { nativeBuildInputs = [ pkgs.sox ]; } ''
          sox -n -r 44100 -c 2 -t ogg $out trim 0.0 0.1
        '';
    };
  };
}
