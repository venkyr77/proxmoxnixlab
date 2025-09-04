{
  config,
  nasIP,
  pkgs,
  props,
  ...
}: {
  imports = [
    ../../modules/services/arr
    (import ../../modules/roles/smb-accessor.nix {
      dataset_to_accessor = {
        "movies" = props.common_config.arr_user_props.user.name;
        "shows" = props.common_config.arr_user_props.user.name;
      };
      inherit config nasIP pkgs;
    })
  ];

  sops = {
    age.keyFile = "/etc/topson/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      mediarr_smbaccess = {
        sopsFile = ../../secrets/mediarr_smbaccess;
      };
      radarr-api-key = {
        sopsFile = ../../secrets/radarr-api-key;
      };
      sonarr-api-key = {
        sopsFile = ../../secrets/sonarr-api-key;
      };
    };
    templates = {
      radarr-api-key-ev = {
        content = ''
          RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}
        '';
        group = "${props.common_config.arr_user_props.group.name}";
        owner = "${props.common_config.arr_user_props.user.name}";
      };
      sonarr-api-key-ev = {
        content = ''
          SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}
        '';
        group = "${props.common_config.arr_user_props.group.name}";
        owner = "${props.common_config.arr_user_props.user.name}";
      };
    };
  };
}
