{ inputs, ... }:

{
  # For machines at my home
  # TODO: remove this?
  imports = with inputs.self.nixosModules; [
    tailscale
    avahi
  ];
}
