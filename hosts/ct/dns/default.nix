{
  imports = [
    ./adg.nix
    ./unbound.nix
  ];

  services.tailscale.enable = true;
}
