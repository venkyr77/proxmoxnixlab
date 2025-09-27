{
  nodes,
  props,
  ...
}: {
  services.gatus = {
    enable = true;
    openFirewall = true;
    settings = {
      endpoints = [
        {
          conditions = [
            "[STATUS] == 200"
            "[BODY] == Healthy"
          ];
          interval = "1m";
          name = "jellyfin";
          url = "http://${props.vms.gpubox.ipv4_short}:${toString nodes.gpubox.config.services.jellyfin.port}/health";
        }
      ];
      web.port = 8080;
    };
  };
}
