{config, ...}: {
  imports = [
    ../../../modules/users/mediarr.nix
  ];

  mediarr.make_user = true;

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
    secrets.lidarr-api-key.sopsFile = ../../../secrets/common/lidarr-api-key;
    templates.lidarr-api-key-ev = {
      content = ''
        LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
