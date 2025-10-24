{config, ...}: {
  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.sonarr-api-key-ev.path}"
    ];
    group = "mediarr";
    openFirewall = true;
    user = "mediarr";
  };

  sops = {
    secrets.sonarr-api-key.sopsFile = ../secrets/sonarr-api-key;
    templates.sonarr-api-key-ev = {
      content = ''
        SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
