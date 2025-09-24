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
  ];

  services.navidrome = {
    enable = true;
    group = "mediarr";
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/mnt/music";
    };
    user = "mediarr";
  };

  sops.secrets.mediarr_smbaccess.sopsFile = ../../../secrets/common/mediarr_smbaccess;

  users = {
    groups.mediarr.gid = 210;
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = 210;
    };
  };
}
