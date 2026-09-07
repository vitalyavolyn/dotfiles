{ config, pkgs, ... }:

{
  # Needed for ryzenadj to get a real SMU mailbox instead of the /dev/mem
  # fallback, which can't write these values on this laptop.
  hardware.cpu.amd.ryzen-smu.enable = true;

  # CPU hit 91C (1C over stock 90C throttle point) right before a thermal
  # shutdown. True undervolt (--set-coall) is firmware-locked on this OEM,
  # so capping power/thermal limits instead: 85C throttle, 20W STAPM
  # (stock 25W). Volatile SMU state -- must be reapplied every boot/resume.
  #
  # Retried a few times below because asusd resets these shortly after
  # startup (its own EC/ThrottlePolicy call, confirmed via journalctl);
  # After=asusd.service alone wasn't enough since that only orders unit
  # start, not asusd's async internal setup.
  systemd.services.cpu-power-limits = {
    description = "Apply conservative CPU power/thermal limits (after asusd settles)";
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
