{
  config,
  nodes,
  props,
  ...
}: {
  services.linkwarden = {
    database = {
      host = props.vms.psql-db.ipv4_short;
      name = "linkwarden";
      inherit (nodes.psql-db.config.services.postgresql.settings) port;
      user = "linkwarden";
    };
    enable = true;
    enableRegistration = true;
    host = "0.0.0.0";
    openFirewall = true;
    port = 5050;
    secretFiles = {
      NEXTAUTH_SECRET = config.sops.secrets.linkwarden-nextauth-secret.path;
      POSTGRES_PASSWORD = config.sops.secrets.linkwarden-postgres-password.path;
    };
  };

  sops.secrets = {
    linkwarden-nextauth-secret = {
      group = "linkwarden";
      owner = "linkwarden";
      sopsFile = ../../../../secrets/linkwarden-nextauth-secret;
    };
    linkwarden-postgres-password = {
      group = "linkwarden";
      owner = "linkwarden";
      sopsFile = ../../../../secrets/linkwarden-db-pass;
    };
  };
}
