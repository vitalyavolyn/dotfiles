{ ... }:

{
  den.aspects.pipewire = {
    nixos = {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        pavucontrol
      ];
    };
  };
}
