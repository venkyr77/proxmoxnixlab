{inputs, ...}: {
  imports = [
    inputs.declarative-jellyfin.nixosModules.default
    ./configarr
    ./jellyfin
    ./lidarr
    ./navidrome
    ./prowlarr
    ./radarr
    ./sabnzbd
    ./sonarr
  ];

  users = {
    groups.mediarr.gid = 210;
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = 210;
    };
  };
}
