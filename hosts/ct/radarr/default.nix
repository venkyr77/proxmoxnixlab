{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "movies" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
    ../../../modules/common/mediarr.nix
  ];

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
    secrets = {
      mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
      radarr-api-key.sopsFile = ../../../secrets/common/radarr-api-key;
    };
    templates.radarr-api-key-ev = {
      content = ''
        RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
