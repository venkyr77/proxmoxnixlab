{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "services";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "len([BODY].results) > 0"
        ];
        interval = "1m";
        name = "searx";
        url = "http://${props.cts.services.ipv4_short}:${toString nodes.services.config.services.searx.settings.server.port}/search?q=test&format=json";
      }
    ];
}
