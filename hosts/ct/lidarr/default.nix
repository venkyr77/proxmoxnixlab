{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "music" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
    ../../../modules/common/mediarr.nix
  ];

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
    secrets = {
      mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
      lidarr-api-key.sopsFile = ../../../secrets/common/lidarr-api-key;
    };
    templates.lidarr-api-key-ev = {
      content = ''
        LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
      '';
      group = "mediarr";
      owner = "mediarr";
    };
  };
}
