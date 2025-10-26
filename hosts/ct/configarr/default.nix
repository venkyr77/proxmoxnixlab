{
  config,
  name,
  ...
}: {
  imports = [
    ./module
    ./config.nix
  ];

  services.configarr = {
    enable = true;
    environmentFile = "${config.sops.templates.configarr-ev.path}";
    group = name;
    user = name;
  };

  sops = {
    secrets = {
      lidarr-api-key.sopsFile = ../../../secrets/lidarr-api-key;
      radarr-api-key.sopsFile = ../../../secrets/radarr-api-key;
      sonarr-api-key.sopsFile = ../../../secrets/sonarr-api-key;
    };
    templates.configarr-ev = {
      content = ''
        LOG_LEVEL=debug
        LOG_STACKTRACE=true
        LIDARR_API_KEY=${config.sops.placeholder.lidarr-api-key}
        RADARR_API_KEY=${config.sops.placeholder.radarr-api-key}
        SONARR_API_KEY=${config.sops.placeholder.sonarr-api-key}
      '';
      inherit (config.services.configarr) group;
      owner = config.services.configarr.user;
    };
  };
}
