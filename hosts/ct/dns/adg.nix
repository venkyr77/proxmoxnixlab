{
  config,
  lib,
  props,
  ...
}: {
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = true;
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
      user_rules =
        [
          "auth"
          "adg"
          "dtn"
          "homepage"
          "gatus"
          "grafana"
          "jellyfin"
          "lidarr"
          "linkwarden"
          "memos"
          "nas"
          "navidrome"
          "ntfysh"
          "prometheus"
          "prowlarr"
          "pve"
          "radarr"
          "sabnzbd"
          "searx"
          "sonarr"
          "vaultwarden"
        ]
        |> map (vhost: [
          ''@@*$client="local"''
          ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.reverse-proxy.ipv4_short},client="local"''
          ''@@*$client="tailscale"''
          ''||${vhost}.euls.dev^$dnsrewrite=${props.cts.reverse-proxy.tailscale_ip},client="tailscale"''
        ])
        |> lib.lists.flatten;
    };
  };
}
