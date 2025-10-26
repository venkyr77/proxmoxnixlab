{config, ...}: {
  networking.firewall.allowedTCPPorts = [config.services.searx.settings.server.port];

  services.searx = {
    enable = true;
    environmentFile = config.sops.secrets.searx-ev.path;
    settings = {
      search.formats = [
        "html"
        "json"
      ];
      server = {
        bind_address = "0.0.0.0";
        port = 8888;
        secret_key = "@SEARX_SECRET_KEY@";
      };
    };
  };

  sops.secrets.searx-ev.sopsFile = ../../../../secrets/searx-ev;
}
