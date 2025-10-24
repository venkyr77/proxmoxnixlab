{config, ...}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "angel";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].database == ok"
          "has([BODY].commit) == true"
          "has([BODY].database) == true"
        ];
        interval = "1m";
        name = "grafana";
        url = "http://localhost:${toString config.services.grafana.settings.server.http_port}/api/health";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == success"
          "[BODY].data.resultType == vector"
          "[BODY].data.result[0].value[1] == ${toString (builtins.foldl'
            (
              i: job:
                i
                + (
                  builtins.foldl'
                  (j: sc: j + builtins.length sc.targets)
                  0
                  job.static_configs
                )
            )
            0
            config.services.prometheus.scrapeConfigs)}"
        ];
        interval = "1m";
        name = "prometheus-server";
        url = "http://localhost:${toString config.services.prometheus.port}/api/v1/query?query=sum(up)";
      }
    ];
}
