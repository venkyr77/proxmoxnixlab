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
        "shows" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
  ];

  fileSystems."/mnt/sabnzbd" = {
    device = "${props.cts.sabnzbd.ipv4_short}:/export/sabnzbd";
    fsType = "nfs";
  };

  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.sonarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets = {
    mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
    sonarr-api-key-ev.sopsFile = ./secrets/sonarr-api-key-ev;
  };
}
