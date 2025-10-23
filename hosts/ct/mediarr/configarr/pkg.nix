{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.configarr;

  configarr_pkg = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck
      pnpm test
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 -t $out/share bundle.cjs
      makeWrapper ${lib.getExe pkgs.nodejs_24} $out/bin/configarr \
        --add-flags "$out/share/bundle.cjs"
      runHook postInstall
    '';

    meta = {
      changelog = "https://github.com/raydak-labs/configarr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
      description = "Sync TRaSH Guides + custom configs with Sonarr/Radarr";
      homepage = "https://github.com/raydak-labs/configarr";
      license = lib.licenses.agpl3Only;
      mainProgram = "configarr";
      maintainers = with lib.maintainers; [lord-valen];
      platforms = lib.platforms.all;
    };

    nativeBuildInputs = [
      pkgs.makeBinaryWrapper
      pkgs.nodejs_24
      pkgs.pnpm.configHook
    ];

    pname = "configarr";

    pnpmDeps = pkgs.pnpm.fetchDeps {
      fetcherVersion = 1;
      hash = "sha256-D5mdlYLXAu9gHNrL45bev1+giVL/9x7oTOUUJmVIE8U=";
      inherit (finalAttrs) pname src version;
    };

    src = pkgs.fetchFromGitHub {
      hash = "sha256-x87N8GAerfyqJHLx7gjFaIPKCDhxZjlQ+MPeLK+vshw";
      owner = "raydak-labs";
      repo = "configarr";
      tag = "v1.15.1";
    };

    version = "1.15.1";
  });
in {
  options.services.configarr = {
    config = lib.mkOption {
      default = "";
      description = "YAML configuration.";
      type = lib.types.string;
    };

    dataDir = lib.mkOption {
      default = "/var/lib/configarr";
      description = "Working directory for Configarr (repos/, config/, etc.).";
      type = lib.types.path;
    };

    enable = lib.mkEnableOption "Configarr synchronization service";

    environmentFile = lib.mkOption {
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
      '';
      type = lib.types.nullOr lib.types.path;
    };

    group = lib.mkOption {
      default = "configarr";
      description = "Group for the Configarr service.";
      type = lib.types.str;
    };

    schedule = lib.mkOption {
      default = "5min";
      description = "Run interval for the timer (applied to OnUnitActiveSec).";
      type = lib.types.str;
    };

    user = lib.mkOption {
      default = "configarr";
      description = "User to run the Configarr service as.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.configarr = {
        after = [
          "network-online.target"
          "systemd-tmpfiles-setup.service"
        ];
        description = "Run Configarr (packaged) once";
        path = [pkgs.git];
        preStart = let
          configFile = pkgs.writeText "configarr-config.yml" cfg.config;
        in ''
          install -D -m 0644 ${configFile} ${cfg.dataDir}/config/config.yml
          chown ${cfg.user}:${cfg.group} ${cfg.dataDir}/config/config.yml
        '';
        serviceConfig = {
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = lib.getExe configarr_pkg;
          Group = cfg.group;
          Type = "oneshot";
          User = cfg.user;
          WorkingDirectory = cfg.dataDir;
        };
        wants = ["network-online.target"];
      };

      timers.configarr = {
        description = "Schedule Configarr run";
        timerConfig = {
          AccuracySec = "30s";
          OnBootSec = "2min";
          OnUnitActiveSec = cfg.schedule;
          Persistent = true;
        };
        wantedBy = ["timers.target"];
      };

      tmpfiles.rules = [
        "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
        "d ${cfg.dataDir}/config 0755 ${cfg.user} ${cfg.group} -"
      ];
    };

    users = {
      groups = lib.mkIf (cfg.group == "configarr") {
        ${cfg.group} = {};
      };

      users = lib.mkIf (cfg.user == "configarr") {
        configarr = {
          description = "configarr user";
          inherit (cfg) group;
          home = cfg.dataDir;
          isSystemUser = true;
        };
      };
    };
  };
}
