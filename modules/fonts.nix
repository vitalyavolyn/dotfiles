{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      font-awesome
      # siji
    ];
  } // (if pkgs.stdenv.isLinux then {
    fontDir.enable = true;
  } else { });
}
