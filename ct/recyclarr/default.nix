{
  config,
  props,
  ...
}: {
  imports = [
    ../../modules/services/mediarr.nix
  ];

  services.recyclarr = {
    configuration = {
      radarr = {
        radarr_instance = {
          api_key._secret = "/run/credentials/recyclarr.service/radarr-api-key";
          base_url = "http://${props.cts.radarr.ipv4_short}:${toString props.common_config.services.radarr.port}";
          custom_formats = import ./custom-formats/radarr.nix;
          delete_old_custom_formats = true;
          quality_profiles = import ./quality-profiles/radarr.nix;
        };
      };
    };
    enable = true;
    group = props.common_config.arr_user_props.group.name;
    user = props.common_config.arr_user_props.user.name;
  };

  sops = {
    age.keyFile = "/etc/recyclarr/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      radarr-api-key = {
        sopsFile = ../../secrets/radarr-api-key;
      };
    };
  };

  systemd.services.recyclarr.serviceConfig.LoadCredential = [
    "radarr-api-key:${config.sops.secrets.radarr-api-key.path}"
  ];
}
