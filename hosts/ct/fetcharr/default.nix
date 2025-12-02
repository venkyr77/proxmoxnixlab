{
  config,
  name,
  ...
}: {
  imports = [
    ./lidarr
    ./nzbhydra
    ./prowlarr
    ./radarr
    ./sabnzbd
    ./sonarr
  ];

  sops = {
    secrets.fetcharr-db-pass.sopsFile = ../../../secrets/fetcharr-db-pass;
    templates.fetcharr-db-pass-ev = {
      content = ''
        FETCHARR_DB_PASS=${config.sops.placeholder.fetcharr-db-pass}
      '';
    };
  };

  users = {
    groups.${name}.gid = 210;
    users.${name} = {
      group = name;
      isSystemUser = true;
      uid = 210;
    };
  };
}
