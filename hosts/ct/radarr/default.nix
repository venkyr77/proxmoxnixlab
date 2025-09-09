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
        "movies" = "mediarr";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
  ];

  boot.supportedFilesystems = ["nfs"];

  fileSystems."/mnt/sabnzbd" = {
    device = "${props.cts.sabnzbd.ipv4_short}:/export/sabnzbd";
    fsType = "nfs";
  };

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.radarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets = {
    mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;
    radarr-api-key-ev.sopsFile = ./secrets/radarr-api-key-ev;
  };
}
