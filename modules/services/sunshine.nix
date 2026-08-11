{ ... }:

{
  den.aspects.sunshine.nixos = { ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      # openFirewall = true;
    };
  };
}
