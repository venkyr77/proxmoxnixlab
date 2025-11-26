{
  config,
  nodes,
  props,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    9000
    9443
  ];

  services.authentik = {
    createDatabase = false;
    enable = true;
    environmentFile = "${config.sops.templates.merged-authentik-ev.path}";
    settings = {
      authentik_host = "https://auth.euls.dev";
      avatars = "initials";
      disable_startup_analytics = true;
    };
  };

  sops = {
    secrets = {
      authentik-ev.sopsFile = ../../../../secrets/authentik-ev;
      authentik-db-pass.sopsFile = ../../../../secrets/authentik-db-pass;
    };
    templates.merged-authentik-ev = {
      content = ''
        ${config.sops.placeholder.authentik-ev}
        AUTHENTIK_POSTGRESQL__HOST="${props.vms.psql-db.ipv4_short}"
        AUTHENTIK_POSTGRESQL__NAME="authentik"
        AUTHENTIK_POSTGRESQL__PASSWORD="${config.sops.placeholder.authentik-db-pass}"
        AUTHENTIK_POSTGRESQL__PORT=${toString nodes.psql-db.config.services.postgresql.settings.port}
        AUTHENTIK_POSTGRESQL__USER="authentik"
      '';
      group = "authentik";
      owner = "authentik";
    };
  };

  users = {
    groups.authentik = {};
    users.authentik = {
      group = "authentik";
      isSystemUser = true;
    };
  };
}
