{
  config,
  nodes,
  pkgs,
  props,
  ...
}: let
  b64 = str:
    builtins.readFile (pkgs.runCommandLocal "b64" {} ''
      printf '%s' '${str}' | base64 -w0 > $out
    '');
in {
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
    startup.completeStartupWizard = true;
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
    plugins = [
      {
        name = "Webhook";
        configuration = {
          GenericOptions = [
            {
              WebhookName = "ntfy";
              WebhookUri = "http://${props.cts.angel.ipv4_short}:${toString nodes.angel.config.services.ntfy-sh.port}";
              NotificationTypes = [
                "PlaybackStart"
              ];
              Template = b64 ''
                {
                  "topic": "jellyfin",

                  {{#if_equals NotificationType "PlaybackStart"}}
                    "priority": 2,
                    "title": "{{{NotificationUsername}}} | Playback started",
                    {{#if_equals ItemType "Episode"}}
                      "message": "User:{{{NotificationUsername}}}\nDevice/Client: {{{DeviceName}}} - {{{ClientName}}}\nIP Address: {{{RemoteEndPoint}}}\nSeries: {{{SeriesName}}}\nPlay Method: {{{PlayMethod}}}\n"
                    {{/if_equals}}
                    {{#if_equals ItemType "Movie"}}
                      "message": "User:{{{NotificationUsername}}}\nDevice/Client: {{{DeviceName}}} - {{{ClientName}}}\nIP Address: {{{RemoteEndPoint}}}\nMovie: {{{Name}}}\nPlay Method: {{{PlayMethod}}}\n"
                    {{/if_equals}}
                  {{/if_equals}}
                }
              '';
              SendAllProperties = false;
              TrimWhitespace = false;
              SkipEmptyMessageBody = false;
            }
          ];
        };
      }
    ];
    version = 1;
  };
}
