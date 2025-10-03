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
    systemd.tmpfiles.rules = [
      "d /mnt/jellyfin 0755 ${cfg.user} ${cfg.group}"
      "d /mnt/jellyfin/transcode 0755 ${cfg.user} ${cfg.group}"
    ];
    users = {
      groups.jellyfin.gid = 210;
      users.jellyfin.uid = 210;
    };
  };
}
