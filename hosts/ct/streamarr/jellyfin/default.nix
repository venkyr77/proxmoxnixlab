{
  config,
  name,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
in {
  imports = [
    ../../../../modules/hardware/intel-igpu.nix
  ];

  options.services.jellyfin.port = pkgs.lib.mkOption {
    default = 8096;
    type = pkgs.lib.types.int;
  };

  config = {
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-ffmpeg
      pkgs.jellyfin-web
    ];

    intel-igpu = {
      enable = true;
      mediagpu_gid = 2999;
      user = name;
    };

    networking.firewall.allowedTCPPorts = [cfg.port];

    services.jellyfin = {
      cacheDir = "/mnt/jellyfin-data/cache";
      enable = true;
      group = name;
      user = name;
    };

    sops = {
      secrets.jellarr-api-key.sopsFile = ../../../../secrets/jellarr-api-key;
      templates.jellarr-api-key-ev.content = ''
        JELLARR_API_KEY=${config.sops.placeholder.jellarr-api-key}
      '';
    };

    systemd.services.jellarr-api-key-maker = {
      after = ["jellyfin.service"];
      path = [
        pkgs.coreutils
        pkgs.sqlite
        pkgs.systemd
      ];
      script =
        #sh
        ''
          set -euo pipefail

          DB="/var/lib/jellyfin/data/jellyfin.db"

          until [ -e "$DB" ]; do
            sleep 1
          done

          systemctl stop jellyfin.service

          sleep 10

          sqlite3 "$DB" <<SQL
          BEGIN IMMEDIATE;
          INSERT INTO ApiKeys (AccessToken, Name, DateCreated, DateLastActivity)
          SELECT ''\'''${JELLARR_API_KEY}','jellarr', datetime('now'), datetime('now')
          WHERE NOT EXISTS (SELECT 1 FROM ApiKeys WHERE Name='jellarr');
          COMMIT;
          SQL

          systemctl start jellyfin.service
        '';
      serviceConfig = {
        EnvironmentFile = config.sops.templates.jellarr-api-key-ev.path;
        Type = "oneshot";
        User = "root";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
