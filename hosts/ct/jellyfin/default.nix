{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
in {
  imports = [
    ../../../modules/hardware/intel-igpu.nix
    ../../../modules/users/mediarr.nix
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
      user = "mediarr";
    };

    mediarr.make_user = true;

    networking.firewall.allowedTCPPorts = [cfg.port];

    services.jellyfin = {
      enable = true;
      group = "mediarr";
      user = "mediarr";
    };

    systemd.tmpfiles.rules = [
      "d /mnt/data 0775 ${cfg.user} ${cfg.group}"
      "d /mnt/data/transcode 0775 ${cfg.user} ${cfg.group}"
    ];
  };
}
