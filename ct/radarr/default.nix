{
  config,
  props,
  ...
}: {
  imports = [
    ../../modules/services/mediarr.nix
  ];

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.radarr-api-key-ev.path}"
    ];
    group = props.common_config.arr_user_props.group.name;
    openFirewall = true;
    settings.server.port = props.common_config.services.radarr.port;
    user = props.common_config.arr_user_props.user.name;
  };

  sops = {
    age.keyFile = "/etc/radarr/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      radarr-api-key-ev = {
        sopsFile = ../../secrets/radarr-api-key-ev;
      };
    };
  };
}
