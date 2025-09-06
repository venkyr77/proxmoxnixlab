{
  config,
  pkgs,
  ...
}: let
  PROMETHEUS_DATASOURCE_UID = "PROMETHEUS_DATASOURCE";
in {
  environment.etc = {
    "grafana-dashboards/node-exporter-full.json" = {
      user = "grafana";
      group = "grafana";
      source = let
        node-exporter-full-grafana-dashboard = pkgs.fetchurl {
          name = "fetch-node-exporter-full-grafana-dashboard";
          url = "https://grafana.com/api/dashboards/1860/revisions/41/download";
          sha256 = "sha256-EywgxEayjwNIGDvSmA/S56Ld49qrTSbIYFpeEXBJlTs=";
        };
        pathced-node-exporter-full-grafana-dashboard =
          pkgs.runCommand
          "patch-node-exporter-full-grafana-dashboard"
          {}
          ''
            cp ${node-exporter-full-grafana-dashboard} $out
            sed -i 's/''${DS_PROMETHEUS}/${PROMETHEUS_DATASOURCE_UID}/g' $out
          '';
      in
        pathced-node-exporter-full-grafana-dashboard;
    };
  };

  services = {
    grafana = {
      enable = true;
      provision = {
        dashboards.settings.providers = [
          {
            name = "Dashboards";
            options.path = "/etc/grafana-dashboards";
          }
        ];
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            uid = "${PROMETHEUS_DATASOURCE_UID}";
            url = "http://localhost:${toString config.services.prometheus.port}";
          }
        ];
      };
      settings.server.http_addr = "0.0.0.0";
    };
  };
}
