{ inputs, ... }:

{
  den.aspects.binbin.nixos = { ... }: {
    imports = [ inputs.binbin.nixosModules.default ];

    services.binbin = {
      enable = true;
      port = inputs.self.lib.homelab.portFor "binbin";
    };
  };
}
