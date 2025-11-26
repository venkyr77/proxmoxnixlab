{
  config,
  nodes,
  pkgs,
  props,
  ...
}: let
  PROMETHEUS_DATASOURCE_UID = "PROMETHEUS_DATASOURCE";
in {
  environment.etc = let
    patchGrafanaDashboard = dashboard:
      pkgs.runCommand
      "patch-grafana-dashboard"
      {}
      ''
        cp ${dashboard} $out
        sed -i 's/''${DS_PROMETHEUS}/${PROMETHEUS_DATASOURCE_UID}/g' $out
      '';
  in {
    "grafana-dashboards/node-exporter-full.json" = {
      user = "grafana";
      group = "grafana";
      source = patchGrafanaDashboard (pkgs.fetchurl {
        name = "fetch-node-exporter-full-grafana-dashboard";
        url = "https://grafana.com/api/dashboards/1860/revisions/41/download";
        sha256 = "sha256-EywgxEayjwNIGDvSmA/S56Ld49qrTSbIYFpeEXBJlTs=";
      });
    };
    "grafana-dashboards/unbound.json" = {
      user = "grafana";
      group = "grafana";
      source = patchGrafanaDashboard (pkgs.fetchurl {
        name = "fetch-unbound-grafana-dashboard";
        url = "https://grafana.com/api/dashboards/21006/revisions/2/download";
        sha256 = "sha256-5hAlTsOj+Nb5KBSzYpZkr283TWW3xzEY7XiEkZyfcl8=";
      });
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.grafana.settings.server.http_port
  ];

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
      settings = {
        database = {
          host = props.vms.psql-db.ipv4_short;
          name = "grafana";
          password = "$__file{${config.sops.secrets.grafana-db-pass.path}}";
          inherit (nodes.psql-db.config.services.postgresql.settings) port;
          ssl_mode = "disable";
          type = "postgres";
          user = "grafana";
        };
        server.http_addr = "0.0.0.0";
      };
    };
  };

  sops.secrets.grafana-db-pass = {
    group = "grafana";
    owner = "grafana";
    sopsFile = ../../../../secrets/grafana-db-pass;
  };
}
