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
          (builtins.attrNames props.cts)
          |> map (ct: {
            targets = ["${props.cts.${ct}.ipv4_short}:${toString nodes.${ct}.config.services.prometheus.exporters.node.port}"];
          });
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = [
              "${props.cts.dns.ipv4_short}:${toString nodes.dns.config.services.prometheus.exporters.unbound.port}"
            ];
          }
        ];
      }
    ];
  };
}
