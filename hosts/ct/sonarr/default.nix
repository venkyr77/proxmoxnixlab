{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "shows" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
    ../../../modules/common/mediarr.nix
  ];

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
    secrets = {
      mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
      sonarr-api-key.sopsFile = ../../../secrets/common/sonarr-api-key;
    };
    templates.sonarr-api-key-ev = {
      content = ''
        SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
