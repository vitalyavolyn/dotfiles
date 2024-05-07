{ pkgs, lib, inputs, stateVersion, ... }:

{
  home = {
    inherit stateVersion;

    packages = with pkgs; [
      firefox
    ];
  };
}
