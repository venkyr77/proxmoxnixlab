{
  nodes,
  props,
  ...
}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "auth-n-pass";
      })
    [
      {
        conditions = [
          "[STATUS] == 200"
          "len([BODY]) > 0"
        ];
        interval = "1m";
        name = "vaultwarden";
        url = "http://${props.cts.auth-n-pass.ipv4_short}:${toString nodes.auth-n-pass.config.services.vaultwarden.config.ROCKET_PORT}/api/alive";
      }
    ];
}
