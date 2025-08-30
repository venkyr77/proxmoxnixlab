{props, ...}: {
  services.prometheus = {
    enable = true;
    inherit (props.common_config.services.prometheus) port;
    scrapeConfigs = [
      {
        job_name = "node";

        static_configs = map (vm: {
          targets = ["${props.vms.${vm}.ipv4_short}:${toString props.common_config.services.prometheus.exporters.node.port}"];
        }) (builtins.attrNames props.vms);
      }
    ];
  };
}
