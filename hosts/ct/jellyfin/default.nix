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

    services.declarative-jellyfin = {
      branding.customCss =
        # css
        ''
          @import url("https://cdn.jsdelivr.net/npm/jellyskin@latest/dist/main.css");
        '';
      cacheDir = "/mnt/jellyfin-data/cache";
      enable = true;
      encoding = {
        enableHardwareEncoding = true;
        hardwareAccelerationType = "vaapi";
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
          "vp8"
          "vp9"
          "av1"
        ];
        enableDecodingColorDepth10Hevc = true;
        enableDecodingColorDepth10HevcRext = true;
        enableDecodingColorDepth12HevcRext = true;
        enableDecodingColorDepth10Vp9 = true;
      };
      group = "mediarr";
      libraries = {
        "Movies - English" = {
          enabled = true;
          contentType = "movies";
          pathInfos = [
            "/mnt/movies/English"
          ];
        };
        "Movies - Tamil" = {
          enabled = true;
          contentType = "movies";
          pathInfos = [
            "/mnt/movies/Tamil"
          ];
        };
        "Shows" = {
          enabled = true;
          contentType = "tvshows";
          pathInfos = [
            "/mnt/shows"
          ];
        };
      };
      system = {
        trickplayOptions = {
          enableHwAcceleration = true;
          enableHwEncoding = true;
        };
      };
      user = "mediarr";
      users = {
        admin = {
          mutable = true;
          password = "test";
          permissions.isAdministrator = true;
        };
      };
    };
  };
}
