{
  config,
  lib,
  props,
  ...
}: let
  cfg = config.services.postgresql;

  dbACL = import ./acl.nix {inherit props;};

  allUsers = lib.unique (
    (map (db: dbACL.${db}.user) (builtins.attrNames dbACL))
    ++ ["pgadmin"]
  );

  authRules = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (dbName: config: "host ${dbName} ${config.user} ${config.host} md5")
    dbACL
  );
in {
  services = {
    pgadmin = {
      enable = true;
      initialEmail = "pgadmin@euls.dev";
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
        ${authRules}
      '';
      enable = true;
      enableTCPIP = true;
    };
  };

  sops = {
    secrets =
      (
        builtins.listToAttrs (
          map (db-user: {
            name = "${db-user}-db-pass";
            value = {sopsFile = ../../../secrets/${db-user}-db-pass;};
          })
          [
            "fetcharr"
            "gatus"
            "grafana"
            "linkwarden"
            "memos"
            "pgadmin"
            "vaultwarden"
          ]
        )
      )
      // {
        pgadmin-ui-pass.sopsFile = ../../../secrets/pgadmin-ui-pass;
      };
    templates = {
      psql-config-env = {
        content =
          lib.concatMapStringsSep "\n" (
            user: ''${lib.toUpper "${user}"}_DBPASS=${config.sops.placeholder."${user}-db-pass"}''
          )
          allUsers;
        group = "postgres";
        owner = "postgres";
      };
    };
  };

  systemd.services.psql-config-maker = {
    after = ["postgresql.service"];
    environment.PGPORT = builtins.toString cfg.settings.port;
    path = [cfg.finalPackage];
    script =
      # sh
      ''
        #!/usr/bin/env bash
        set -euo pipefail

        check-connection() {
          psql -d postgres -v ON_ERROR_STOP=1 <<-'  EOF'
            SELECT pg_is_in_recovery() \gset
            \if :pg_is_in_recovery
            \i still-recovering
            \endif
          EOF
        }

        while ! check-connection 2> /dev/null; do
          if ! systemctl is-active --quiet postgresql.service; then
            exit 1
          fi
          sleep 0.1
        done

        PGADMIN_EXISTS=$(psql -tAc "SELECT 1 FROM pg_user WHERE usename = 'pgadmin'")

        if [ -z "$PGADMIN_EXISTS" ]; then
          psql -tAc "CREATE USER pgadmin WITH PASSWORD ''\'''${PGADMIN_DBPASS}' CREATEDB CREATEROLE SUPERUSER"
        else
          psql -tAc "ALTER USER pgadmin WITH PASSWORD ''\'''${PGADMIN_DBPASS}'"
          psql -tAc "ALTER USER pgadmin CREATEDB CREATEROLE SUPERUSER"
        fi

        ${lib.concatMapStringsSep "\n" (
          db: let
            inherit (dbACL.${db}) user;
          in ''
            USER_EXISTS=$(psql -tAc "SELECT 1 FROM pg_user WHERE usename = '${user}'")

            if [ -z "$USER_EXISTS" ]; then
              ENV_NAME="$(echo '${user}' | tr '[:lower:]-' '[:upper:]_')_DBPASS"
              PASSWORD="''${!ENV_NAME}"
              psql -tAc "CREATE USER \"${user}\" WITH PASSWORD ''\'''${PASSWORD}'"
            fi

            DB_EXISTS=$(psql -tAc "SELECT 1 FROM pg_database WHERE datname = '${db}'")

            if [ -z "$DB_EXISTS" ]; then
              psql -tAc "CREATE DATABASE \"${db}\" OWNER \"${user}\""
            else
              psql -tAc "ALTER DATABASE \"${db}\" OWNER TO \"${user}\""
            fi
          ''
        ) (builtins.attrNames dbACL)}
      '';
    serviceConfig = {
      EnvironmentFile = config.sops.templates.psql-config-env.path;
      Group = "postgres";
      Type = "oneshot";
      User = "postgres";
    };
    wantedBy = ["multi-user.target"];
  };

  networking.firewall.allowedTCPPorts = [5432];
}
