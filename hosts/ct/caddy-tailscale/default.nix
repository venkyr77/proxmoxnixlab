{
  config,
  nodes,
  pkgs,
  props,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services = {
    caddy = {
      enable = true;
      environmentFile = "${config.sops.secrets.caddy-ev.path}";
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        email {env.CLOUDFLARE_EMAIL}
      '';
      package = pkgs.caddy.withPlugins {
        hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      };
      virtualHosts = {
        "adg.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.adg.ipv4_short}:${toString nodes.adg.config.services.adguardhome.port}
        '';
        "grafana.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.monitor.ipv4_short}:${toString nodes.monitor.config.services.grafana.settings.server.http_port}
        '';
        "jellyfin.euls.dev".extraConfig = ''
          reverse_proxy ${props.vms.gpubox.ipv4_short}:${toString nodes.gpubox.config.services.jellyfin.port}
        '';
        "lidarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.lidarr.settings.server.port}
        '';
        "navidrome.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.navidrome.ipv4_short}:${toString nodes.navidrome.config.services.navidrome.settings.Port}
        '';
        "prometheus.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.monitor.ipv4_short}:${toString nodes.monitor.config.services.prometheus.port}
        '';
        "prowlarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.prowlarr.settings.server.port}
        '';
        "radarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.radarr.settings.server.port}
        '';
        "sabnzbd.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.sabnzbd.port}
        '';
        "searx.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.searx.ipv4_short}:${toString nodes.searx.config.services.searx.settings.server.port}
        '';
        "sonarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.sonarr.settings.server.port}
        '';
        "vaultwarden.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.vaultwarden.ipv4_short}:${toString nodes.vaultwarden.config.services.vaultwarden.config.ROCKET_PORT}
        '';
      };
    };
    tailscale.enable = true;
  };

  sops.secrets.caddy-ev.sopsFile = ./secrets/caddy-ev;
}
