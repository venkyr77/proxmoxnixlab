{
  nodes,
  pkgs,
  props,
  ...
}: {
  services.configarr.config =
    # yaml
    ''
      customFormatDefinitions: ${(pkgs.lib.generators.toYAML {} (import ./custom-format-definitions))}

      lidarr:
        lidarr_instance:
          api_key: !env LIDARR_API_KEY
          base_url: http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.lidarr.settings.server.port}
          custom_formats: ${(pkgs.lib.generators.toYAML {} (import ./custom-formats/lidarr.nix))}
          delete_unmanaged_custom_formats:
            enabled: true
          media_management:
            downloadPropersAndRepacks: doNotPrefer
          media_naming:
            standardTrackFormat: "{Album Title} {(Album Disambiguation)}/{Artist Name}_{Album Title}_{track:00}_{Track Title}"
            multiDiscTrackFormat: "{Album Title} {(Album Disambiguation)}/{Artist Name}_{Album Title}_{medium:00}-{track:00}_{Track Title}"
            artistFolderFormat: "{Artist Name}"
          quality_profiles: ${(pkgs.lib.generators.toYAML {} (import ./quality-profiles/lidarr.nix))}
          delete_unmanaged_quality_profiles:
            enabled: true
          download_clients:
          - enable: true
            protocol: usenet
            priority: 1
            removeCompletedDownloads: true
            removeFailedDownloads: true
            name: SABnzbd
            implementationName: SABnzbd
            implementation: Sabnzbd
            configContract: SabnzbdSettings
            infoLink: https://wiki.servarr.com/lidarr/supported#sabnzbd
            tags: []
            fields:
              - name: host
                value: ${props.cts.fetcharr.ipv4_short}
              - name: port
                value: ${toString nodes.fetcharr.config.services.sabnzbd.port}
              - name: useSsl
                value: false
              - name: urlBase
              - name: apiKey
                value: !env SABNZBD_API_KEY
              - name: username
              - name: password
              - name: musicCategory
                value: music
              - name: recentMusicPriority
                value: -100
              - name: olderMusicPriority
                value: -100

      radarr:
        radarr_instance:
          api_key: !env RADARR_API_KEY
          base_url: http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.radarr.settings.server.port}
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
          delete_unmanaged_quality_profiles:
            enabled: true
          root_folders:
            - /mnt/movies/English
            - /mnt/movies/Tamil
          download_clients:
          - enable: true
            protocol: usenet
            priority: 1
            removeCompletedDownloads: true
            removeFailedDownloads: true
            name: SABnzbd
            implementationName: SABnzbd
            implementation: Sabnzbd
            configContract: SabnzbdSettings
            infoLink: https://wiki.servarr.com/radarr/supported#sabnzbd
            tags: []
            fields:
              - name: host
                value: ${props.cts.fetcharr.ipv4_short}
              - name: port
                value: ${toString nodes.fetcharr.config.services.sabnzbd.port}
              - name: useSsl
                value: false
              - name: urlBase
              - name: apiKey
                value: !env SABNZBD_API_KEY
              - name: username
              - name: password
              - name: movieCategory
                value: movies
              - name: recentMoviePriority
                value: -100
              - name: olderMoviePriority
                value: -100

      sonarr:
        sonarr_instance:
          api_key: !env SONARR_API_KEY
          base_url: http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.sonarr.settings.server.port}
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
          delete_unmanaged_quality_profiles:
            enabled: true
          root_folders:
            - /mnt/shows
          download_clients:
          - enable: true
            protocol: usenet
            priority: 1
            removeCompletedDownloads: true
            removeFailedDownloads: true
            name: SABnzbd
            implementationName: SABnzbd
            implementation: Sabnzbd
            configContract: SabnzbdSettings
            infoLink: https://wiki.servarr.com/sonarr/supported#sabnzbd
            tags: []
            fields:
              - name: host
                value: ${props.cts.fetcharr.ipv4_short}
              - name: port
                value: ${toString nodes.fetcharr.config.services.sabnzbd.port}
              - name: useSsl
                value: false
              - name: urlBase
              - name: apiKey
                value: !env SABNZBD_API_KEY
              - name: username
              - name: password
              - name: tvCategory
                value: tv
              - name: recentTvPriority
                value: -100
              - name: olderTvPriority
                value: -100
    '';
}
