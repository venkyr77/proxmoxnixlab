{
  services.homepage-dashboard = {
    allowedHosts = "homepage.euls.dev";
    enable = true;
    openFirewall = true;
    services = [
      {
        HYPERVISOR = [
          {
            "proxmox" = {
              icon = "proxmox.svg";
              href = "https://pve.euls.dev";
            };
          }
        ];
      }
      {
        STORAGE = [
          {
            "NAS" = {
              icon = "truenas.svg";
              href = "https://nas.euls.dev";
            };
          }
          {
            "DTN" = {
              icon = "truenas.svg";
              href = "https://dtn.euls.dev";
            };
          }
        ];
      }
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
        "MONITORING & ALERTS" = [
          {
            "gatus" = {
              icon = "gatus.svg";
              href = "https://gatus.euls.dev";
            };
          }
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
            "ntfy-sh" = {
              icon = "ntfy.svg";
              href = "https://ntfysh.euls.dev";
            };
          }
        ];
      }
      {
        TOOLS = [
          {
            "linkwarden" = {
              icon = "linkwarden.png";
              href = "https://linkwarden.euls.dev";
            };
          }
          {
            "memos" = {
              icon = "memos.png";
              href = "https://memos.euls.dev";
            };
          }
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
