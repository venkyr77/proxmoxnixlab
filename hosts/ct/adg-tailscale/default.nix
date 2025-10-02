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
        clients = {
          persistent = [
            {
              ids = ["10.0.0.0/24"];
              name = "local";
              use_global_settings = true;
            }
            {
              ids = ["100.64.0.0/10"];
              name = "tailscale";
              use_global_settings = true;
            }
          ];
        };
        dns = {
          bootstrap_dns = ["${props.cts.unbound.ipv4_short}"];
          cache_enabled = false;
          upstream_dns = ["${props.cts.unbound.ipv4_short}"];
        };
        user_rules = let
          mkRule = vhost: [
            ''@@*$client="local"''
            ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.caddy-tailscale.ipv4_short},client="local"''
            ''@@*$client="tailscale"''
            ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.caddy-tailscale.tailscale_ip},client="tailscale"''
          ];
        in
          mkRule "auth"
          ++ mkRule "adg"
          ++ mkRule "homepage"
          ++ mkRule "gatus"
          ++ mkRule "grafana"
          ++ mkRule "jellyfin"
          ++ mkRule "lidarr"
          ++ mkRule "navidrome"
          ++ mkRule "prometheus"
          ++ mkRule "prowlarr"
          ++ mkRule "radarr"
          ++ mkRule "sabnzbd"
          ++ mkRule "searx"
          ++ mkRule "sonarr"
          ++ mkRule "vaultwarden";
      };
      openFirewall = true;
    };

    resolved.enable = false;

    tailscale.enable = true;
  };
}
