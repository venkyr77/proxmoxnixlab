{nodes, ...}: {
  services.gatus.settings.endpoints =
    nodes.reverse-proxy.config.services.caddy.virtualHosts
    |> builtins.attrNames
    |> map (virtual_host: {
      conditions = [
        "[STATUS] == 200"
      ];
      group = "reverse-proxy";
      interval = "1m";
      name = virtual_host;
      url = "https://${virtual_host}";
    });
}
