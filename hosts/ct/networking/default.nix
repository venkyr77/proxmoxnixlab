{
  imports = [
    ./caddy
    ./dns
  ];

  services.tailscale.enable = true;
}
