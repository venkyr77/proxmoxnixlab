{
  config,
  props,
  ...
}: {
  imports = [
    ../../modules/services/mediarr.nix
  ];

  services.recyclarr = {
    configuration = {
      radarr.radarr_instance = {
        api_key._secret = "/run/credentials/recyclarr.service/radarr-api-key";
        base_url = "http://${props.cts.radarr.ipv4_short}:${toString props.common_config.services.radarr.port}";
        custom_formats = import ./custom-formats/radarr.nix;
        delete_old_custom_formats = true;
        include = [
          {
            template = "radarr-quality-definition-movie";
          }
        ];
        media_naming = {
          folder = "default";
          movie = {
            rename = true;
            standard = "jellyfin-imdb";
          };
        };
        quality_profiles = import ./quality-profiles/radarr.nix;
      };
      sonarr.sonarr_instance = {
        api_key._secret = "/run/credentials/recyclarr.service/sonarr-api-key";
        base_url = "http://${props.cts.sonarr.ipv4_short}:${toString props.common_config.services.sonarr.port}";
        custom_formats = import ./custom-formats/sonarr.nix;
        delete_old_custom_formats = true;
        include = [
          {
            template = "sonarr-quality-definition-series";
          }
        ];
        media_naming = {
          episodes = {
            anime = "default";
            daily = "default";
            rename = true;
            standard = "default";
          };
          season = "default";
          series = "default";
        };
        quality_profiles = import ./quality-profiles/sonarr.nix;
      };
    };
    enable = true;
    group = props.common_config.arr_user_props.group.name;
    user = props.common_config.arr_user_props.user.name;
  };

  sops = {
    age.keyFile = "/etc/recyclarr/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      radarr-api-key = {
        sopsFile = ../../secrets/radarr-api-key;
      };
      sonarr-api-key = {
        sopsFile = ../../secrets/sonarr-api-key;
      };
    };
  };

  systemd.services.recyclarr.serviceConfig.LoadCredential = [
    "radarr-api-key:${config.sops.secrets.radarr-api-key.path}"
    "sonarr-api-key:${config.sops.secrets.sonarr-api-key.path}"
  ];
}
