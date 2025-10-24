{
  config,
  props,
  ...
}: {
  services.adguardhome = {
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
        bootstrap_dns = ["127.0.0.1:${toString config.services.unbound.settings.server.port}"];
        cache_enabled = false;
        upstream_dns = ["127.0.0.1:${toString config.services.unbound.settings.server.port}"];
      };
      user_rules = let
        mkRule = vhost: [
          ''@@*$client="local"''
          ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.networking.ipv4_short},client="local"''
          ''@@*$client="tailscale"''
          ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.networking.tailscale_ip},client="tailscale"''
        ];
      in
        mkRule "auth"
        ++ mkRule "adg"
        ++ mkRule "dtn"
        ++ mkRule "homepage"
        ++ mkRule "gatus"
        ++ mkRule "grafana"
        ++ mkRule "jellyfin"
        ++ mkRule "lidarr"
        ++ mkRule "linkwarden"
        ++ mkRule "memos"
        ++ mkRule "nas"
        ++ mkRule "navidrome"
        ++ mkRule "ntfysh"
        ++ mkRule "prometheus"
        ++ mkRule "prowlarr"
        ++ mkRule "pve"
        ++ mkRule "radarr"
        ++ mkRule "sabnzbd"
        ++ mkRule "searx"
        ++ mkRule "sonarr"
        ++ mkRule "vaultwarden";
    };
  };
}
