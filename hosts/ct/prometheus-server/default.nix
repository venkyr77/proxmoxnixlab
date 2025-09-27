{
  config,
  nodes,
  props,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    config.services.prometheus.port
  ];

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs =
          (
            map (ct: {targets = ["${ct}.local:${toString nodes.${ct}.config.services.prometheus.exporters.node.port}"];})
            (builtins.attrNames props.cts)
          )
          ++ (
            map (vm: {targets = ["${vm}.local:${toString nodes.${vm}.config.services.prometheus.exporters.node.port}"];})
            (builtins.attrNames props.vms)
          );
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = [
              "unbound.local:${toString nodes.unbound.config.services.prometheus.exporters.unbound.port}"
            ];
          }
        ];
      }
    ];
  };
}
