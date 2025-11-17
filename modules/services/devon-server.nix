{ inputs, ... }:

{
  imports = [
    inputs.devon-server.nixosModules.devon-server
  ];

  services.devon-server.enable = true;
}
