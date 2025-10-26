{
  config,
  name,
  pkgs,
  ...
}: {
  imports = [
    ./lidarr
    ./prowlarr
    ./radarr
    ./sabnzbd
    ./sonarr
  ];

  systemd.services.fetcharr-config-maker = let
    sabApiKey = "$(< ${config.sops.secrets.sabnzbd-api-key.path})";

    mkCfgJson = category_prefix: category: priority_infix:
      builtins.toJSON {
        host = "localhost";
        port = 8082;
        useSsl = false;
        apiKey = sabApiKey;
        "${category_prefix}Category" = category;
        "recent${priority_infix}Priority" = -100;
        "older${priority_infix}Priority" = -100;
      };

    cfgJsonLidarr = mkCfgJson "music" "music" "Music";
    cfgJsonRadarr = mkCfgJson "movie" "movies" "Movie";
    cfgJsonSonarr = mkCfgJson "tv" "tv" "Tv";
  in {
    after = ["lidarr.service" "radarr.service" "sonarr.service"];
    wants = ["lidarr.service" "radarr.service" "sonarr.service"];
    path = with pkgs; [sqlite coreutils systemd];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script =
      # sh
      ''
        set -euo pipefail

        declare -A APPS=(
          [lidarr]="/var/lib/lidarr/.config/Lidarr/lidarr.db"
          [radarr]="/var/lib/radarr/.config/Radarr/radarr.db"
          [sonarr]="/var/lib/sonarr/.config/NzbDrone/sonarr.db"
        )

        upsert_client() {
          local app="$1" db="$2" json="$3"

          for i in $(seq 1 30); do
            [ -f "$db" ] && break
            sleep 1
          done

          sqlite3 "$db" <<SQL
        BEGIN IMMEDIATE;
        DELETE FROM DownloadClients WHERE Name='SABnzbd';
        INSERT INTO DownloadClients
        (Enable, Name, Implementation, Settings, ConfigContract, Priority, RemoveCompletedDownloads, RemoveFailedDownloads, Tags)
        VALUES
        (1, 'SABnzbd', 'Sabnzbd', '$json', 'SabnzbdSettings', 1, 1, 1, '[]');
        COMMIT;
        SQL
        }

        upsert_client lidarr "''${APPS[lidarr]}" '${cfgJsonLidarr}'
        upsert_client radarr "''${APPS[radarr]}" '${cfgJsonRadarr}'
        upsert_client sonarr "''${APPS[sonarr]}" '${cfgJsonSonarr}'

        LIDARR_DB="''${APPS[lidarr]}"
        sqlite3 "$LIDARR_DB" <<'SQL'
        BEGIN IMMEDIATE;
        UPDATE NamingConfig
        SET
          ReplaceIllegalCharacters = 1,
          ArtistFolderFormat = '{Artist Name}',
          RenameTracks = 1,
          StandardTrackFormat = '{Album Title} {(Album Disambiguation)}/{Artist Name}_{Album Title}_{track:00}_{Track Title}',
          MultiDiscTrackFormat = '{Album Title} {(Album Disambiguation)}/{Artist Name}_{Album Title}_{medium:00}-{track:00}_{Track Title}',
          ColonReplacementFormat = 4
        WHERE Id = 1;
        COMMIT;
        SQL

        sqlite3 "$LIDARR_DB" <<'SQL'
        BEGIN IMMEDIATE;
        UPDATE MetadataProfiles
        SET
          PrimaryAlbumTypes = '[
            { "primaryAlbumType": 2, "allowed": true },
            { "primaryAlbumType": 4, "allowed": false },
            { "primaryAlbumType": 1, "allowed": true },
            { "primaryAlbumType": 3, "allowed": false },
            { "primaryAlbumType": 0, "allowed": true }
          ]',
          SecondaryAlbumTypes = '[
            { "secondaryAlbumType": 0, "allowed": true },
            { "secondaryAlbumType": 3, "allowed": false },
            { "secondaryAlbumType": 2, "allowed": true },
            { "secondaryAlbumType": 7, "allowed": true },
            { "secondaryAlbumType": 9, "allowed": false },
            { "secondaryAlbumType": 6, "allowed": false },
            { "secondaryAlbumType": 4, "allowed": false },
            { "secondaryAlbumType": 8, "allowed": true },
            { "secondaryAlbumType": 10, "allowed": false },
            { "secondaryAlbumType": 1, "allowed": true },
            { "secondaryAlbumType": 11, "allowed": false }
          ]'
        WHERE Name = 'Standard';
        COMMIT;
        SQL
      '';
    wantedBy = ["multi-user.target"];
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
