{
  arr,
  config,
  lib,
  nodes,
  pkgs,
  props,
  ...
}: {
  systemd.services."${arr}-psql-shifter" = {
    after = ["${arr}.service"];
    path = [
      pkgs.coreutils
      pkgs.sqlite
      pkgs.systemd
      pkgs.xmlstarlet
    ];
    script =
      # sh
      ''
        set -euo pipefail

        CONFIG_FILE="${config.services.${arr}.dataDir}/config.xml"

        until [ -f "$CONFIG_FILE" ]; do
          sleep 1
        done

        systemctl stop ${arr}.service

        sleep 5

        xmlstarlet ed -L ${
          {
            PostgresHost = props.vms.psql-db.ipv4_short;
            PostgresPort = toString nodes.psql-db.config.services.postgresql.settings.port;
            PostgresUser = "fetcharr";
            PostgresPassword = "$FETCHARR_DB_PASS";
            PostgresMainDb = "${arr}-main";
            PostgresLogDb = "${arr}-logs";
          }
          |> builtins.mapAttrs (name: value: ''-d "/Config/${name}" -s "/Config" -t elem -n "${name}" -v "${value}"'')
          |> builtins.attrValues
          |> lib.concatStringsSep " "
        } "$CONFIG_FILE"

        systemctl start ${arr}.service
      '';
    serviceConfig = {
      EnvironmentFile = config.sops.templates.fetcharr-db-pass-ev.path;
      Type = "oneshot";
      User = "root";
    };
    wantedBy = ["multi-user.target"];
  };
}
