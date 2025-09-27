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
        url = "http://${props.cts.prowlarr.ipv4_short}:${toString nodes.prowlarr.config.services.prowlarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "lidarr";
        url = "http://${props.cts.lidarr.ipv4_short}:${toString nodes.lidarr.config.services.lidarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "radarr";
        url = "http://${props.cts.radarr.ipv4_short}:${toString nodes.radarr.config.services.radarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          "[BODY].status == OK"
        ];
        interval = "1m";
        name = "sonarr";
        url = "http://${props.cts.sonarr.ipv4_short}:${toString nodes.sonarr.config.services.sonarr.settings.server.port}/ping";
      }
      {
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<a class="navbar-logo" href="./">*)''
        ];
        interval = "1m";
        name = "sabnzbd";
        url = "http://${props.cts.sabnzbd.ipv4_short}:${toString nodes.sabnzbd.config.services.sabnzbd.port}";
      }
    ];
}
