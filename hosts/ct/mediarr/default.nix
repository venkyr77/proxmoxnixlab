{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "movies" = "mediarr";
        "music" = "mediarr";
        "shows" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
    ./recyclarr
    ./lidarr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sabnzbd.nix
    ./sonarr.nix
  ];

  sops = {
    secrets = {
      mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
      lidarr-api-key.sopsFile = ./secrets/lidarr-api-key;
      radarr-api-key.sopsFile = ./secrets/radarr-api-key;
      sonarr-api-key.sopsFile = ./secrets/sonarr-api-key;
    };
    templates = {
      lidarr-api-key-ev = {
        content = ''
          LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
        '';
        group = "mediarr";
        owner = "mediarr";
      };
      radarr-api-key-ev = {
        content = ''
          RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}
        '';
        group = "mediarr";
        owner = "mediarr";
      };
      sonarr-api-key-ev = {
        content = ''
          SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}
        '';
        group = "mediarr";
        owner = "mediarr";
      };
    };
  };

  users = {
    groups.mediarr.gid = 210;
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = 210;
    };
  };
}
