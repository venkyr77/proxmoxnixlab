{
  nodes,
  pkgs,
  props,
}: let
  lidarr_base_url = "http://${props.cts.fetcharr.ipv4_short}:${toString nodes.fetcharr.config.services.lidarr.settings.server.port}";
in
  # sh
  ''
    #!/usr/bin/env bash

    set -euo pipefail

    standard_id=$(
      ${pkgs.lib.getExe pkgs.curl} -s "${lidarr_base_url}/api/v1/metadataprofile?apikey=''${LIDARR_API_KEY}" |
        ${pkgs.lib.getExe pkgs.jq} -r '.[] | select(.name == "Standard") | .id'
    )

    if [ -n "$standard_id" ]; then
      echo "Found Standard profile with ID: $standard_id, upserting Standard profile..."

      ${pkgs.lib.getExe pkgs.curl} -s -X 'PUT' \
        "${lidarr_base_url}/api/v1/metadataprofile/''${standard_id}?apikey=''${LIDARR_API_KEY}" \
        -H 'Content-Type: application/json' \
        -d '{
          "id": '"$standard_id"',
          "name": "Standard",
          "primaryAlbumTypes": [
            {"albumType": {"id": 2}, "allowed": true},
            {"albumType": {"id": 4}, "allowed": false},
            {"albumType": {"id": 1}, "allowed": true},
            {"albumType": {"id": 3}, "allowed": false},
            {"albumType": {"id": 0}, "allowed": true}
          ],
          "secondaryAlbumTypes": [
            {"albumType": {"id": 0}, "allowed": true},
            {"albumType": {"id": 3}, "allowed": false},
            {"albumType": {"id": 2}, "allowed": true},
            {"albumType": {"id": 7}, "allowed": true},
            {"albumType": {"id": 9}, "allowed": false},
            {"albumType": {"id": 6}, "allowed": false},
            {"albumType": {"id": 4}, "allowed": false},
            {"albumType": {"id": 8}, "allowed": true},
            {"albumType": {"id": 10}, "allowed": false},
            {"albumType": {"id": 1}, "allowed": true},
            {"albumType": {"id": 11}, "allowed": false}
          ],
          "releaseStatuses": [
            {"releaseStatus": {"id": 0}, "allowed": true},
            {"releaseStatus": {"id": 1}, "allowed": false},
            {"releaseStatus": {"id": 2}, "allowed": false},
            {"releaseStatus": {"id": 3}, "allowed": false}
          ]
        }' | ${pkgs.lib.getExe pkgs.jq} .

      echo "Standard profile upserted!"
    else
      echo "Standard profile not found"
    fi
  ''
