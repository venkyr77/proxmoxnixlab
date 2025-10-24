{config, ...}: {
  imports = [
    ./config.nix
    ./pkg.nix
  ];

  services.configarr = {
    enable = true;
    environmentFile = "${config.sops.templates.configarr-ev.path}";
    group = "mediarr";
    user = "mediarr";
  };

  sops.templates.configarr-ev = {
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
}
