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
            map (ct: {targets = ["${props.cts.${ct}.ipv4_short}:${toString nodes.${ct}.config.services.prometheus.exporters.node.port}"];})
            (builtins.attrNames props.cts)
          )
          ++ (
            map (vm: {targets = ["${props.vms.${vm}.ipv4_short}:${toString nodes.${vm}.config.services.prometheus.exporters.node.port}"];})
            (builtins.attrNames props.vms)
          );
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = [
              "${props.cts.unbound.ipv4_short}:${toString nodes.unbound.config.services.prometheus.exporters.unbound.port}"
            ];
          }
        ];
      }
    ];
  };
}
