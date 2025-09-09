{
  config,
  nasIP,
  pkgs,
  props,
  ...
}: {
  imports = [
    ../../../modules/common/mediarr.nix
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "music" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
  ];

  fileSystems."/mnt/sabnzbd" = {
    device = "${props.cts.sabnzbd.ipv4_short}:/export/sabnzbd";
    fsType = "nfs";
  };

  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.lidarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets = {
    mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
    lidarr-api-key-ev.sopsFile = ./secrets/lidarr-api-key-ev;
  };
}
