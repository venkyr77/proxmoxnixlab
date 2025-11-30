{
  config,
  inputs,
  lib,
  name,
  pkgs,
  ...
}: {
  imports = [
    inputs.configarr.nixosModules.default
    ./config.nix
  ];

  services.configarr = {
    dataDir = "/var/lib/configarr-new";
    enable = true;
    environmentFile = "${config.sops.templates.configarr-ev.path}";
    group = name;
    package = import ./package.nix {inherit lib pkgs;};
    user = name;
  };

  sops = {
    secrets = {
      lidarr-api-key.sopsFile = ../../../../secrets/lidarr-api-key;
      radarr-api-key.sopsFile = ../../../../secrets/radarr-api-key;
      sonarr-api-key.sopsFile = ../../../../secrets/sonarr-api-key;
      sabnzbd-api-key.sopsFile = ../../../../secrets/sabnzbd-api-key;
    };
    templates.configarr-ev = {
      content = ''
        LOG_LEVEL=debug
        LOG_STACKTRACE=true
        LIDARR_API_KEY=${config.sops.placeholder.lidarr-api-key}
        RADARR_API_KEY=${config.sops.placeholder.radarr-api-key}
        SONARR_API_KEY=${config.sops.placeholder.sonarr-api-key}
        SABNZBD_API_KEY=${config.sops.placeholder.sabnzbd-api-key}
      '';
      inherit (config.services.configarr) group;
      owner = config.services.configarr.user;
    };
  };
}
