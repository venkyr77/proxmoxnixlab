{
  config,
  lib,
  nodes,
  pkgs,
  props,
  ...
}: let
  cfg = config.services.memos;
in {
  options.services.memos.port = lib.mkOption {
    type = lib.types.int;
    default = 8080;
  };

  config = {
    networking.firewall.allowedTCPPorts = [cfg.port];

    services.memos = {
      enable = true;
      environmentFile = config.sops.templates.memos-ev.path;
      package = import ./package.nix {inherit pkgs;};
    };

    sops = {
      secrets.memos-db-pass.sopsFile = ../../../../secrets/memos-db-pass;
      templates.memos-ev = {
        content = ''
          MEMOS_ADDR="0.0.0.0"
          MEMOS_DATA="${cfg.dataDir}"
          MEMOS_DRIVER="postgres"
          MEMOS_DSN="postgresql://memos:${config.sops.placeholder.memos-db-pass}@${props.vms.psql-db.ipv4_short}:${toString nodes.psql-db.config.services.postgresql.settings.port}/memos?sslmode=disable"
          MEMOS_INSTANCE_URL="https://memos.euls.dev"
          MEMOS_MODE="prod"
          MEMOS_PORT="${toString cfg.port}"
        '';
        inherit (cfg) group;
        owner = cfg.user;
      };
    };
  };
}
