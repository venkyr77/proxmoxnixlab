{
  config,
  lib,
  ...
}: let
  cfg = config.services.ntfy-sh;
in {
  options.services.ntfy-sh.port = lib.mkOption {
    type = lib.types.int;
    default = 8888;
  };

  config = {
    networking.firewall.allowedTCPPorts = [cfg.port];
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfysh.euls.dev";
        listen-http = ":${toString cfg.port}";
      };
    };
  };
}
