{
  config,
  nodes,
  props,
  ...
}: {
  networking.firewall.allowedTCPPorts = [config.services.vaultwarden.config.ROCKET_PORT];

  services.vaultwarden = {
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
    dbBackend = "postgresql";
    enable = true;
    environmentFile = config.sops.templates.vaultwarden-ev.path;
  };

  sops = {
    secrets.vaultwarden-db-pass.sopsFile = ../../../../secrets/vaultwarden-db-pass;
    templates.vaultwarden-ev = {
      content = ''
        DATABASE_URL="postgresql://vaultwarden:${config.sops.placeholder.vaultwarden-db-pass}@${props.vms.psql-db.ipv4_short}:${toString nodes.psql-db.config.services.postgresql.settings.port}/vaultwarden?sslmode=disable"
      '';
      group = "vaultwarden";
      owner = "vaultwarden";
    };
  };
}
