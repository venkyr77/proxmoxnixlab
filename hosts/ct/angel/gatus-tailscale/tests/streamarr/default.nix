{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "streamarr";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == Healthy"
        ];
        interval = "1m";
        name = "jellyfin";
        url = "http://${props.cts.streamarr.ipv4_short}:${toString nodes.streamarr.config.services.jellyfin.port}/health";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == ."
        ];
        interval = "1m";
        name = "navidrome";
        url = "http://${props.cts.streamarr.ipv4_short}:${toString nodes.streamarr.config.services.navidrome.settings.Port}/ping";
      }
    ];
}
