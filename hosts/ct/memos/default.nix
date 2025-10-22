{
  config,
  lib,
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
      settings = {
        MEMOS_ADDR = "0.0.0.0";
        MEMOS_DATA = cfg.dataDir;
        MEMOS_DRIVER = "sqlite";
        MEMOS_INSTANCE_URL = "https://memos.euls.dev";
        MEMOS_MODE = "prod";
        MEMOS_PORT = "${toString cfg.port}";
      };
    };
  };
}
