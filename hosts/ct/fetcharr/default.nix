{name, ...}: {
  imports = [
    ./lidarr
    ./prowlarr
    ./radarr
    ./sabnzbd
    ./sonarr
  ];

  users = {
    groups.${name}.gid = 210;
    users.${name} = {
      group = name;
      isSystemUser = true;
      uid = 210;
    };
  };
}
