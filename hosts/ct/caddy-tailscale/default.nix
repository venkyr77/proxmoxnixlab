{
  config,
  dtnIP,
  nasIP,
  nodes,
  pkgs,
  props,
  pveIP,
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
        hash = "sha256-XwZ0Hkeh2FpQL/fInaSq+/3rCLmQRVvwBM0Y1G1FZNU=";
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
      };
      virtualHosts = {
        "auth.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.authentik.ipv4_short}:9000
        '';
        "adg.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.adg-tailscale.ipv4_short}:${toString nodes.adg-tailscale.config.services.adguardhome.port}
        '';
        "dtn.euls.dev".extraConfig = ''
          reverse_proxy ${dtnIP}
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
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.jellyfin.port}
        '';
        "lidarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.lidarr.settings.server.port}
        '';
        "linkwarden.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.linkwarden.ipv4_short}:${toString nodes.linkwarden.config.services.linkwarden.port}
        '';
        "memos.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.memos.ipv4_short}:${toString nodes.memos.config.services.memos.port}
        '';
        "nas.euls.dev".extraConfig = ''
          reverse_proxy ${nasIP}
        '';
        "navidrome.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.navidrome.settings.Port}
        '';
        "ntfysh.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.ntfy-sh.ipv4_short}:${toString nodes.ntfy-sh.config.services.ntfy-sh.port}
        '';
        "prometheus.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.prometheus-server.ipv4_short}:${toString nodes.prometheus-server.config.services.prometheus.port}
        '';
        "prowlarr.euls.dev".extraConfig = ''
          reverse_proxy ${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.prowlarr.settings.server.port}
        '';
        "pve.euls.dev".extraConfig = ''
          reverse_proxy ${pveIP}:8006 {
            transport http {
              tls_insecure_skip_verify
            }
          }
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
