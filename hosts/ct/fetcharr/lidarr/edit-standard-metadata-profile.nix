{config}:
# sh
''
  DB="${config.services.lidarr.dataDir}/lidarr.db"

  until [ -e "$DB" ]; do
    sleep 1
  done

  systemctl stop lidarr.service

  sleep 5

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

  systemctl start lidarr.service
''
