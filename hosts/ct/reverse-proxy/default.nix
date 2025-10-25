{
  imports = [
    ./caddy.nix
  ];

  services.tailscale.enable = true;
}
