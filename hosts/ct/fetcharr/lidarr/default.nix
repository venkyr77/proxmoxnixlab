{
  config,
  name,
  pkgs,
  ...
}: {
  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.lidarr-api-key-ev.path}"
    ];
    group = name;
    openFirewall = true;
    user = name;
  };

  sops = {
    secrets.lidarr-api-key.sopsFile = ../../../../secrets/lidarr-api-key;
    templates.lidarr-api-key-ev = {
      content = ''
        LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
      '';
      group = name;
      owner = name;
    };
  };

  systemd.services.lidarr-config-maker = {
    after = ["lidarr.service"];
    path = with pkgs; [
      coreutils
      sqlite
      systemd
    ];
    script =
      # sh
      ''
        set -euo pipefail

        systemctl stop lidarr.service

        sleep 10

        DB="/var/lib/lidarr/.config/Lidarr/lidarr.db"

        sqlite3 "$DB" <<'SQL'
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

        sleep 10

        systemctl start lidarr.service
      '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    wantedBy = ["multi-user.target"];
  };
}
