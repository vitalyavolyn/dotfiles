{ ... }:

{
  den.aspects.fail2ban.nixos = { config, lib, ... }: {
    services.fail2ban.enable = lib.mkDefault config.networking.firewall.enable;
  };
}
