{
  imports = [
    ./tests
  ];

  services = {
    gatus = {
      enable = true;
      openFirewall = true;
      settings = {
        storage = {
          path = "/var/lib/gatus/data.db";
          type = "sqlite";
        };
        ui.default-sort-by = "group";
        web.port = 7777;
      };
    };

    tailscale.enable = true;
  };

  systemd.services.gatus.serviceConfig.StateDirectory = "gatus";
}
