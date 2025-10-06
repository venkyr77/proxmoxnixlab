{config, ...}: {
  imports = [
    ../../../modules/users/mediarr.nix
    ./config.nix
    ./pkg.nix
  ];

  mediarr.make_user = true;

  services.configarr = {
    enable = true;
    environmentFile = "${config.sops.templates.configarr-ev.path}";
    group = "mediarr";
    user = "mediarr";
  };

  sops = {
    secrets = {
      lidarr-api-key.sopsFile = ../../../secrets/common/lidarr-api-key;
      radarr-api-key.sopsFile = ../../../secrets/common/radarr-api-key;
      sonarr-api-key.sopsFile = ../../../secrets/common/sonarr-api-key;
    };
    templates.configarr-ev = {
      content = ''
        LOG_LEVEL=debug
        LOG_STACKTRACE=true
        LIDARR_API_KEY=${config.sops.placeholder.lidarr-api-key}
        RADARR_API_KEY=${config.sops.placeholder.radarr-api-key}
        SONARR_API_KEY=${config.sops.placeholder.sonarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
