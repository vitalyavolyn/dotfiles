{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      font-awesome
      # siji
    ];
  };
}
