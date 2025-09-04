{
  config,
  nasIP,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/hardware/graphics/nvidia.nix
    (import ../../modules/roles/smb-accessor.nix {
      dataset_to_accessor = {
        "movies" = "jellyfin";
        "shows" = "jellyfin";
      };
      inherit config nasIP pkgs;
    })
    ../../modules/services/jellyfin.nix
  ];

  sops = {
    age.keyFile = "/etc/miracle/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      jellyfin_smbaccess = {
        sopsFile = ../../secrets/jellyfin_smbaccess;
      };
    };
  };
}
