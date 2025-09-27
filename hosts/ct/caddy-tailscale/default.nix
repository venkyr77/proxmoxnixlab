{
  config,
  nodes,
  pkgs,
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
        hash = "sha256-j+xUy8OAjEo+bdMOkQ1kVqDnEkzKGTBIbMDVL7YDwDY=";
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      };
      virtualHosts = {
        "adg.euls.dev".extraConfig = ''
          reverse_proxy adg-tailscale.local:${toString nodes.adg-tailscale.config.services.adguardhome.port}
        '';
        "homepage.euls.dev".extraConfig = ''
          reverse_proxy homepage.local:${toString nodes.homepage.config.services.homepage-dashboard.listenPort}
        '';
        "grafana.euls.dev".extraConfig = ''
          reverse_proxy grafana.local:${toString nodes.grafana.config.services.grafana.settings.server.http_port}
        '';
        "jellyfin.euls.dev".extraConfig = ''
          reverse_proxy gpubox.local:${toString nodes.gpubox.config.services.jellyfin.port}
        '';
        "lidarr.euls.dev".extraConfig = ''
          reverse_proxy lidarr.local:${toString nodes.lidarr.config.services.lidarr.settings.server.port}
        '';
        "navidrome.euls.dev".extraConfig = ''
          reverse_proxy navidrome.local:${toString nodes.navidrome.config.services.navidrome.settings.Port}
        '';
        "prometheus.euls.dev".extraConfig = ''
          reverse_proxy prometheus-server.local:${toString nodes.prometheus-server.config.services.prometheus.port}
        '';
        "prowlarr.euls.dev".extraConfig = ''
          reverse_proxy prowlarr.local:${toString nodes.prowlarr.config.services.prowlarr.settings.server.port}
        '';
        "radarr.euls.dev".extraConfig = ''
          reverse_proxy radarr.local:${toString nodes.radarr.config.services.radarr.settings.server.port}
        '';
        "sabnzbd.euls.dev".extraConfig = ''
          reverse_proxy sabnzbd.local:${toString nodes.sabnzbd.config.services.sabnzbd.port}
        '';
        "searx.euls.dev".extraConfig = ''
          reverse_proxy searx.local:${toString nodes.searx.config.services.searx.settings.server.port}
        '';
        "sonarr.euls.dev".extraConfig = ''
          reverse_proxy sonarr.local:${toString nodes.sonarr.config.services.sonarr.settings.server.port}
        '';
        "uptimekuma.euls.dev".extraConfig = ''
          reverse_proxy uptime-kuma.local:${toString nodes.uptime-kuma.config.services.uptime-kuma.settings.PORT}
        '';
        "vaultwarden.euls.dev".extraConfig = ''
          reverse_proxy vaultwarden.local:${toString nodes.vaultwarden.config.services.vaultwarden.config.ROCKET_PORT}
        '';
      };
    };

    tailscale.enable = true;
  };

  sops.secrets.caddy-ev.sopsFile = ./secrets/caddy-ev;
}
