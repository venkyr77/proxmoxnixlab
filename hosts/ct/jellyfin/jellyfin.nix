{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
in {
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
    networking.firewall.allowedTCPPorts = [cfg.port];
    services.jellyfin.enable = true;
  };
}
