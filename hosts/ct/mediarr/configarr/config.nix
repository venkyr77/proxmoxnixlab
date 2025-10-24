{
  config,
  pkgs,
  ...
}: {
  services.configarr.config =
    # yaml
    ''
      customFormatDefinitions: ${(pkgs.lib.generators.toYAML {} (import ./custom-format-definitions))}

      lidarr:
        lidarr_instance:
          api_key: !env LIDARR_API_KEY
          base_url: http://localhost:${toString config.services.lidarr.settings.server.port}
          custom_formats: ${(pkgs.lib.generators.toYAML {} (import ./custom-formats/lidarr.nix))}
          delete_unmanaged_custom_formats:
            enabled: true
          media_management:
            downloadPropersAndRepacks: doNotPrefer
          quality_profiles: ${(pkgs.lib.generators.toYAML {} (import ./quality-profiles/lidarr.nix))}

      radarr:
        radarr_instance:
          api_key: !env RADARR_API_KEY
          base_url: http://localhost:${toString config.services.radarr.settings.server.port}
          custom_formats: ${(pkgs.lib.generators.toYAML {} (import ./custom-formats/radarr.nix))}
          delete_unmanaged_custom_formats:
            enabled: true
          include:
            - template: radarr-quality-definition-movie
          media_management:
            downloadPropersAndRepacks: doNotPrefer
          media_naming:
            folder: default
            movie:
              rename: true
              standard: jellyfin-imdb
          quality_profiles: ${(pkgs.lib.generators.toYAML {} (import ./quality-profiles/radarr.nix))}
          root_folders:
            - /mnt/movies/English
            - /mnt/movies/Tamil

      sonarr:
        sonarr_instance:
          api_key: !env SONARR_API_KEY
          base_url: http://localhost:${toString config.services.sonarr.settings.server.port}
          custom_formats: ${(pkgs.lib.generators.toYAML {} (import ./custom-formats/sonarr.nix))}
          delete_unmanaged_custom_formats:
            enabled: true
          include:
            - template: sonarr-quality-definition-series
          media_management:
            downloadPropersAndRepacks: doNotPrefer
          media_naming:
            episodes:
              anime: default
              daily: default
              rename: true
              standard: default
            season: default
            series: default
          quality_profiles: ${(pkgs.lib.generators.toYAML {} (import ./quality-profiles/sonarr.nix))}
          root_folders:
            - /mnt/shows
    '';
}
