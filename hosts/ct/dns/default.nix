{
  imports = [
    ./adg.nix
    ./unbound.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services = {
    resolved.enable = false;
    tailscale.enable = true;
  };
}
