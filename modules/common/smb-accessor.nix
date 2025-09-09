{
  config,
  dataset_to_accessor,
  isVM,
  nasIP,
  pkgs,
}: let
  datasets = builtins.attrNames dataset_to_accessor;
in {
  environment.systemPackages = [pkgs.cifs-utils];

  fileSystems = builtins.listToAttrs (map (ds: let
      accessor = dataset_to_accessor.${ds};
    in {
      name = "/mnt/${ds}";
      value = {
        device = "//${nasIP}/${builtins.baseNameOf ds}";
        fsType = "cifs";
        options =
          (
            if isVM
            then [
              "noauto"
              "x-systemd.automount"
              "x-systemd.device-timeout=5s"
              "x-systemd.idle-timeout=60"
              "x-systemd.mount-timeout=5s"
            ]
            else []
          )
          ++ [
            "credentials=${config.sops.secrets."${accessor}_smbaccess".path}"
            "nodev"
            "noexec"
            "noperm"
            "nosuid"
            "seal"
            "vers=3.1.1"
          ];
      };
    })
    datasets);
}
