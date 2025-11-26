{
  config,
  nodes,
  props,
  ...
}: {
  services.jellarr.config = {
    base_url = "http://${props.cts.streamarr.ipv4_short}:${toString nodes.streamarr.config.services.jellyfin.port}";
    branding = {
      customCss =
        # css
        ''
          @import url("https://cdn.jsdelivr.net/npm/jellyskin@latest/dist/main.css");
        '';
      loginDisclaimer =
        #html
        ''
          Configured by <a href="https://github.com/venkyr77/jellarr">Jellarr</a>
        '';
      splashscreenEnabled = false;
    };
    encoding = {
      allowAv1Encoding = false;
      allowHevcEncoding = false;
      enableDecodingColorDepth10Hevc = true;
      enableDecodingColorDepth10HevcRext = true;
      enableDecodingColorDepth12HevcRext = true;
      enableDecodingColorDepth10Vp9 = true;
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
      vaapiDevice = "/dev/dri/renderD128";
    };
    library.virtualFolders = [
      {
        collectionType = "movies";
        name = "Movies - English";
        libraryOptions.pathInfos = [
          {
            path = "/mnt/movies/English";
          }
        ];
      }
      {
        collectionType = "movies";
        name = "Movies - Tamil";
        libraryOptions.pathInfos = [
          {
            path = "/mnt/movies/Tamil";
          }
        ];
      }
      {
        collectionType = "tvshows";
        name = "Shows";
        libraryOptions.pathInfos = [
          {
            path = "/mnt/shows";
          }
        ];
      }
    ];
    system = {
      enableMetrics = true;
      pluginRepositories = [
        {
          enabled = true;
          name = "Jellyfin Official";
          url = "https://repo.jellyfin.org/releases/plugin/manifest.json";
        }
      ];
      trickplayOptions = {
        enableHwAcceleration = true;
        enableHwEncoding = true;
      };
    };
    users = [
      {
        name = "admin";
        passwordFile = config.sops.secrets.jellyfin-admin-pass.path;
        policy.isAdministrator = true;
      }
    ];
    version = 1;
  };
}
