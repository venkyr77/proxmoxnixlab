{config, ...}: {
  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.lidarr-api-key-ev.path}"
    ];
    group = "mediarr";
    openFirewall = true;
    user = "mediarr";
  };

  sops = {
    secrets.lidarr-api-key.sopsFile = ../secrets/lidarr-api-key;
    templates.lidarr-api-key-ev = {
      content = ''
        LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
