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
        acme_ca https://acme-staging-v02.api.letsencrypt.org/directory
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        email {env.CLOUDFLARE_EMAIL}
      '';
      package = pkgs.caddy.withPlugins {
        hash = "sha256-j+xUy8OAjEo+bdMOkQ1kVqDnEkzKGTBIbMDVL7YDwDY=";
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      };
      virtualHosts = {
        "auth.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.authentik.ipv4_short}:9000
        '';
        "adg.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.adg-tailscale.ipv4_short}:${toString nodes.adg-tailscale.config.services.adguardhome.port}
        '';
        "homepage.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.homepage.ipv4_short}:${toString nodes.homepage.config.services.homepage-dashboard.listenPort}
        '';
        "gatus.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.gatus-tailscale.ipv4_short}:${toString nodes.gatus-tailscale.config.services.gatus.settings.web.port}
        '';
        "grafana.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.grafana.ipv4_short}:${toString nodes.grafana.config.services.grafana.settings.server.http_port}
        '';
        "jellyfin.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.jellyfin.ipv4_short}:${toString nodes.jellyfin.config.services.jellyfin.port}
        '';
        "lidarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.lidarr.ipv4_short}:${toString nodes.lidarr.config.services.lidarr.settings.server.port}
        '';
        "navidrome.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.navidrome.ipv4_short}:${toString nodes.navidrome.config.services.navidrome.settings.Port}
        '';
        "prometheus.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.prometheus-server.ipv4_short}:${toString nodes.prometheus-server.config.services.prometheus.port}
        '';
        "prowlarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.prowlarr.ipv4_short}:${toString nodes.prowlarr.config.services.prowlarr.settings.server.port}
        '';
        "radarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.radarr.ipv4_short}:${toString nodes.radarr.config.services.radarr.settings.server.port}
        '';
        "sabnzbd.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.sabnzbd.ipv4_short}:${toString nodes.sabnzbd.config.services.sabnzbd.port}
        '';
        "searx.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.searx.ipv4_short}:${toString nodes.searx.config.services.searx.settings.server.port}
        '';
        "sonarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.sonarr.ipv4_short}:${toString nodes.sonarr.config.services.sonarr.settings.server.port}
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
