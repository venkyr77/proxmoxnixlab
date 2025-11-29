{
  config,
  lib,
  ...
}: {
  services.gatus.settings.endpoints =
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
          "[BODY].data.result[0].value[1] == ${toString (
            config.services.prometheus.scrapeConfigs
            |> map (scrape_config: scrape_config.static_configs)
            |> lib.lists.flatten
            |> map (static_config: builtins.length static_config.targets)
            |> (targets: builtins.foldl' (i: j: i + j) 0 targets)
          )}"
        ];
        interval = "1m";
        name = "prometheus-server";
        url = "http://localhost:${toString config.services.prometheus.port}/api/v1/query?query=sum(up)";
      }
    ]
    |> map (endpoint_conf: endpoint_conf // {group = "angel";});
}
