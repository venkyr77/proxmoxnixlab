{
  arr,
  config,
  lib,
  nodes,
  props,
}:
# sh
''
  CONFIG_FILE="${config.services.${arr}.dataDir}/config.xml"

  until [ -f "$CONFIG_FILE" ]; do
    sleep 1
  done

  systemctl stop ${arr}.service

  sleep 5

  xmlstarlet ed -L ${lib.concatStringsSep " " (builtins.attrValues (
    builtins.mapAttrs (name: value: ''-s "/Config" -t elem -n "${name}" -v "${value}"'')
    {
      PostgresHost = props.vms.psql-db.ipv4_short;
      PostgresPort = toString nodes.psql-db.config.services.postgresql.settings.port;
      PostgresUser = "fetcharr";
      PostgresPassword = "$FETCHARR_DB_PASS";
      PostgresMainDb = "${arr}-main";
      PostgresLogDb = "${arr}-logs";
    }
  ))} "$CONFIG_FILE"

  systemctl start ${arr}.service
''
