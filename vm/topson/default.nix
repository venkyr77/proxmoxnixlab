{
  config,
  props,
  ...
}: {
  imports = [
    ../../modules/services/arr
  ];

  sops = {
    age.keyFile = "/etc/topson/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
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
