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
        url = "http://${props.vms.gpubox.ipv4_short}:${toString nodes.gpubox.config.services.jellyfin.port}/health";
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
