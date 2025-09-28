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
        url = "http://${props.cts.searx.ipv4_short}:${toString nodes.searx.config.services.searx.settings.server.port}/search?q=test&format=json";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "len([BODY]) > 0"
        ];
        interval = "1m";
        name = "vaultwarden";
        url = "http://${props.cts.vaultwarden.ipv4_short}:${toString nodes.vaultwarden.config.services.vaultwarden.config.ROCKET_PORT}/api/alive";
      }
    ];
}
