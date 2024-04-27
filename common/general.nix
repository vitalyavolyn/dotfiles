{ pkgs, ... }:

{
  time.timeZone = "Asia/Oral";

  environment.variables.FLAKE = "/etc/nixos";
}
