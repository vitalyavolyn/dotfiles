{ inputs, ... }:

let
  mkApp = import ../_mk-app.nix;
  package = pkgs: inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.work-cal-export;
in
{
  den.aspects.work-cal-export = mkApp {
    darwinHome = { config, pkgs, ... }:
      let
        workCalExport = package pkgs;
        logPath = "${config.home.homeDirectory}/Library/Logs/work-cal-export.log";
      in
      {
        home.packages = [ workCalExport ];

        launchd.agents.work-cal-export = {
          enable = true;
          config = {
            ProgramArguments = [ "${workCalExport}/bin/work-cal-export" ];
            RunAtLoad = true;
            StartInterval = 3600;
            StandardOutPath = logPath;
            StandardErrorPath = logPath;
          };
        };
      };
  };
}
