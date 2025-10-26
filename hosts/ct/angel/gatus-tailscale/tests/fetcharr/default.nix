{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "fetcharr";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "prowlarr";
        url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.prowlarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "lidarr";
        url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.lidarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "radarr";
        url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.radarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "sonarr";
        url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.sonarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<a class="navbar-logo" href="./">*)''
        ];
        interval = "1m";
        name = "sabnzbd";
        url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.sabnzbd.port}";
      }
    ];
}
