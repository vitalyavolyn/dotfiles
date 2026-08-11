{ ... }:

let
  packages = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      fira-code
      font-awesome
      # siji
    ];
  };
in
{
  den.aspects.fonts = {
    os = packages;

    nixos.fonts.fontDir.enable = true;
  };
}
