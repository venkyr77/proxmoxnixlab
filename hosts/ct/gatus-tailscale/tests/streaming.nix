{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "streaming";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == Healthy"
        ];
        interval = "1m";
        name = "jellyfin";
        url = "http://${props.cts.jellyfin.ipv4_short}:${toString nodes.jellyfin.config.services.jellyfin.port}/health";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == ."
        ];
        interval = "1m";
        name = "navidrome";
        url = "http://${props.cts.navidrome.ipv4_short}:${toString nodes.navidrome.config.services.navidrome.settings.Port}/ping";
      }
    ];
}
