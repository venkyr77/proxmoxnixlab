{props, ...}: {
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services = {
    adguardhome = {
      enable = true;
      mutableSettings = false;
      settings = {
        dns = {
          bootstrap_dns = ["${props.cts.unbound.ipv4_short}"];
          cache_enabled = false;
          upstream_dns = ["${props.cts.unbound.ipv4_short}"];
        };
      };
      openFirewall = true;
    };

    resolved.enable = false;
  };
}
