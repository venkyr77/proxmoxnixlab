{props, ...}: {
  services.prometheus = {
    enable = true;
    inherit (props.common_config.services.prometheus) port;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = let
          node_exporter_port = props.common_config.services.prometheus.exporters.node.port;
        in
          (
            map (ct: {targets = ["${props.cts.${ct}.ipv4_short}:${toString node_exporter_port}"];})
            (builtins.attrNames props.cts)
          )
          ++ (
            map (vm: {targets = ["${props.vms.${vm}.ipv4_short}:${toString node_exporter_port}"];})
            (builtins.attrNames props.vms)
          );
      }
    ];
  };
}
