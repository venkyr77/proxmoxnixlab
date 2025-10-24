{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "mediarr";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "prowlarr";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.prowlarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "lidarr";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.lidarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "radarr";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.radarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "sonarr";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.sonarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<a class="navbar-logo" href="./">*)''
        ];
        interval = "1m";
        name = "sabnzbd";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.sabnzbd.port}";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == Healthy"
        ];
        interval = "1m";
        name = "jellyfin";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.jellyfin.port}/health";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY] == ."
        ];
        interval = "1m";
        name = "navidrome";
        url = "http://${props.cts.mediarr.ipv4_short}:${toString nodes.mediarr.config.services.navidrome.settings.Port}/ping";
      }
    ];
}
