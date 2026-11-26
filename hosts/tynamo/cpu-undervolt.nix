{ config, pkgs, ... }:

{
  hardware.cpu.amd.ryzen-smu.enable = true;

  # having some random shutdowns. true undervolt (--set-coall) is firmware-locked,
  # so capping power/thermal limits instead.
  systemd.services.cpu-power-limits = {
    description = "Apply conservative CPU power/thermal limits";
    after = [ "asusd.service" ];
    wants = [ "asusd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "apply-cpu-power-limits" ''
        for i in 1 2 3 4 5; do
          ${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=85 --stapm-limit=20000
          sleep 3
        done
      '';
    };
  };

  powerManagement.resumeCommands = ''
    ${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=85 --stapm-limit=20000
  '';
}
