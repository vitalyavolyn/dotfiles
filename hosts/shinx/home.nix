{ pkgs, lib, inputs, ... }:

{
  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      firefox
    ];
  };
}
