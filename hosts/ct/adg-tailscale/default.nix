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
        filtering.rewrites = [
          {
            domain = "*.euls.dev";
            answer = "${props.cts.caddy-tailscale.tailscale_ip}";
          }
        ];
      };
      openFirewall = true;
    };

    resolved.enable = false;

    tailscale.enable = true;
  };
}
