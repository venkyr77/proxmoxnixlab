{
  services.homepage-dashboard = {
    allowedHosts = "homepage.euls.dev";
    enable = true;
    openFirewall = true;
    services = [
      {
        DNS = [
          {
            "adguard-unbound" = {
              icon = "adguard-home.png";
              href = "https://adg.euls.dev";
            };
          }
        ];
      }
      {
        ARR-STACK = [
          {
            "sabnzbd" = {
              icon = "sabnzbd.svg";
              href = "https://sabnzbd.euls.dev";
            };
          }
          {
            "prowlarr" = {
              icon = "prowlarr.svg";
              href = "https://prowlarr.euls.dev";
            };
          }
          {
            "lidarr" = {
              icon = "lidarr.svg";
              href = "https://lidarr.euls.dev";
            };
          }
          {
            "radarr" = {
              icon = "radarr.svg";
              href = "https://radarr.euls.dev";
            };
          }
          {
            "sonarr" = {
              icon = "sonarr.svg";
              href = "https://sonarr.euls.dev";
            };
          }
        ];
      }
      {
        STREAMING = [
          {
            "jellyfin" = {
              icon = "jellyfin.svg";
              href = "https://jellyfin.euls.dev";
            };
          }
          {
            "navidrome" = {
              icon = "navidrome.svg";
              href = "https://navidrome.euls.dev";
            };
          }
        ];
      }
      {
        MONITORING = [
          {
            "grafana" = {
              icon = "grafana.svg";
              href = "https://grafana.euls.dev";
            };
          }
          {
            "prometheus" = {
              icon = "prometheus.svg";
              href = "https://prometheus.euls.dev";
            };
          }
          {
            "uptime-kuma" = {
              icon = "uptime-kuma.svg";
              href = "https://uptimekuma.euls.dev";
            };
          }
        ];
      }
      {
        TOOLS = [
          {
            "searx" = {
              icon = "searx.svg";
              href = "https://searx.euls.dev";
            };
          }
          {
            "vaultwarden" = {
              icon = "vaultwarden.svg";
              href = "https://vaultwarden.euls.dev";
            };
          }
        ];
      }
    ];
  };
}
