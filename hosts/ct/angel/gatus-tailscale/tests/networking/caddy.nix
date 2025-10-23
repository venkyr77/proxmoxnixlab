{nodes, ...}: {
  services.gatus.settings.endpoints = map (virtual_host: {
    conditions = [
      "[STATUS] == 200"
    ];
    group = "caddy";
    interval = "1m";
    name = virtual_host;
    url = "https://${virtual_host}";
  }) (builtins.attrNames nodes.networking.config.services.caddy.virtualHosts);
}
