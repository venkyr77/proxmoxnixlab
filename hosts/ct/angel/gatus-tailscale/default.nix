{
  config,
  nodes,
  props,
  ...
}: {
  imports = [
    ./tests
  ];

  services = {
    gatus = {
      enable = true;
      environmentFile = config.sops.templates.gatus-ev.path;
      openFirewall = true;
      settings = {
        storage = {
          path = "$GATUS_DSN";
          type = "postgres";
        };
        ui.default-sort-by = "group";
        web.port = 7777;
      };
    };

    tailscale.enable = true;
  };

  sops = {
    secrets.gatus-db-pass.sopsFile = ../../../../secrets/gatus-db-pass;
    templates.gatus-ev = {
      content = ''
        GATUS_DSN="postgresql://gatus:${config.sops.placeholder.gatus-db-pass}@${props.vms.psql-db.ipv4_short}:${toString nodes.psql-db.config.services.postgresql.settings.port}/gatus?sslmode=disable"
      '';
      group = "gatus";
      owner = "gatus";
    };
  };

  systemd.services.gatus.serviceConfig.StateDirectory = "gatus";

  users = {
    groups.gatus = {};
    users.gatus = {
      group = "gatus";
      isSystemUser = true;
    };
  };
}
