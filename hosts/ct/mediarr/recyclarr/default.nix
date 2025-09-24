{
  config,
  props,
  ...
}: {
  services.recyclarr = {
    configuration = {
      radarr.radarr_instance = {
        api_key._secret = "/run/credentials/recyclarr.service/radarr-api-key";
        base_url = "http://${props.cts.mediarr.ipv4_short}:${toString config.services.radarr.settings.server.port}";
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
        replace_existing_custom_formats = true;
      };

      sonarr.sonarr_instance = {
        api_key._secret = "/run/credentials/recyclarr.service/sonarr-api-key";
        base_url = "http://${props.cts.mediarr.ipv4_short}:${toString config.services.sonarr.settings.server.port}";
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
        replace_existing_custom_formats = true;
      };
    };
    enable = true;
    group = "mediarr";
    user = "mediarr";
  };

  systemd.services.recyclarr.serviceConfig.LoadCredential = [
    "radarr-api-key:${config.sops.secrets.radarr-api-key.path}"
    "sonarr-api-key:${config.sops.secrets.sonarr-api-key.path}"
  ];
}
