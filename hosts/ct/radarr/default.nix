{config, ...}: {
  imports = [
    ../../../modules/users/mediarr.nix
  ];

  mediarr.make_user = true;

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.radarr-api-key-ev.path}"
    ];
    group = "mediarr";
    openFirewall = true;
    user = "mediarr";
  };

  sops = {
    secrets.radarr-api-key.sopsFile = ../../../secrets/common/radarr-api-key;
    templates.radarr-api-key-ev = {
      content = ''
        RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
