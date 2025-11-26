{config, ...}: {
  services = {
    pgadmin = {
      enable = true;
      initialEmail = "admin@euls.dev";
      initialPasswordFile = config.sops.secrets.pgadmin-ui-pass.path;
      openFirewall = true;
      port = 5050;
      settings = {
        DEFAULT_SERVER = "0.0.0.0";
      };
    };

    postgresql = {
      authentication = ''
        local all all trust
      '';
      enable = true;
      enableTCPIP = true;
      initialScript = config.sops.templates.postgres-init-script.path;
    };
  };

  sops = {
    secrets = {
      pgadmin-db-pass.sopsFile = ../../../secrets/pgadmin-db-pass;
      pgadmin-ui-pass.sopsFile = ../../../secrets/pgadmin-ui-pass;
    };
    templates.postgres-init-script = {
      content =
        # sql
        ''
          CREATE USER pgadmin WITH PASSWORD '${config.sops.placeholder.pgadmin-db-pass}' CREATEDB CREATEROLE SUPERUSER;
        '';
      group = "postgres";
      owner = "postgres";
    };
  };

  networking.firewall.allowedTCPPorts = [5432];
}
