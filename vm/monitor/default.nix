{props, ...}: {
  imports = [
    ./modules/services/grafana.nix
    ./modules/services/prometheus-server.nix
  ];

  networking.firewall.allowedTCPPorts = [
    props.common_config.services.grafana.settings.server.http_port
    props.common_config.services.prometheus.port
  ];
}
