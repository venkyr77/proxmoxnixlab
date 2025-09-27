{
  imports = [
    ./tests
  ];

  services.gatus = {
    enable = true;
    openFirewall = true;
    settings = {
      storage = {
        path = "/var/lib/gatus/data.db";
        type = "sqlite";
      };
      ui.default-sort-by = "group";
      web.port = 8080;
    };
  };

  systemd.services.gatus.serviceConfig.StateDirectory = "gatus";
}
