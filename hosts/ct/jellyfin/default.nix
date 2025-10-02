{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    (import ../../../modules/common/smb-accessor.nix {
      dataset_to_accessor = {
        "movies" = "jellyfin";
        "shows" = "jellyfin";
      };
      isVM = false;
      inherit config nasIP pkgs;
    })
    ../../../modules/common/intel-igpu.nix
    ./jellyfin.nix
  ];

  intel-igpu = {
    enable = true;
    mediagpu_gid = 2999;
    user = "jellyfin";
  };

  sops.secrets.jellyfin_smbaccess.sopsFile = ./secrets/jellyfin_smbaccess;
}
