_: {
  imports = [
    ./adg
    ./unbound
  ];

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services.resolved.enable = false;
}
