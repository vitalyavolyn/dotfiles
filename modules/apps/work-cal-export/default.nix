# See work-cal-export.swift for what this does and its config.
# Sets up an hourly launch agent too.
{ pkgs, ... }:

let
  workCalExport = pkgs.stdenv.mkDerivation {
    pname = "work-cal-export";
    version = "1.0.0";
    src = ./work-cal-export.swift;
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.swift ];

    buildPhase = ''
      runHook preBuild
      swiftc -parse-as-library "$src" -o work-cal-export
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp work-cal-export $out/bin/
      runHook postInstall
    '';
  };
in
{
  home-manager.users.vitalya.home.packages = [ workCalExport ];

  launchd.user.agents.work-cal-export = {
    command = "${workCalExport}/bin/work-cal-export";
    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 3600;
      StandardOutPath = "/Users/vitalya/Library/Logs/work-cal-export.log";
      StandardErrorPath = "/Users/vitalya/Library/Logs/work-cal-export.log";
    };
  };
}
