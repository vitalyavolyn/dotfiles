{ ... }:

{
  den.aspects.server-tuning.nixos = {
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    services.journald.settings.Journal.SystemMaxUse = "500M";
  };
}
