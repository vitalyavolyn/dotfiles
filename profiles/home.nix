{ inputs, ... }:

{
  # For machines at my home
  imports = with inputs.self.nixosModules; [
    tailscale
    avahi
  ];
}
