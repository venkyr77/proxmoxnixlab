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
      inherit config nasIP pkgs;
    })
    ./jellyfin.nix
    ./nvidia.nix
  ];

  sops.secrets.jellyfin_smbaccess.sopsFile = ./secrets/jellyfin_smbaccess;
}
