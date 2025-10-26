{config, ...}: {
  services.prowlarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.prowlarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops = {
    secrets.prowlarr-api-key.sopsFile = ../../../../secrets/prowlarr-api-key;
    templates.prowlarr-api-key-ev = {
      content = ''
        PROWLARR__AUTH__APIKEY=${config.sops.placeholder.prowlarr-api-key}
      '';
      group = "root";
      owner = "root";
    };
  };
}
