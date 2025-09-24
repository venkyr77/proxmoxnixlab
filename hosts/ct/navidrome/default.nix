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
}
