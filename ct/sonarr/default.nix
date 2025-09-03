{
  config,
  props,
  ...
}: {
  imports = [
    ../../modules/services/mediarr.nix
  ];

  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.sonarr-api-key-ev.path}"
    ];
    group = props.common_config.arr_user_props.group.name;
    openFirewall = true;
    settings.server.port = props.common_config.services.sonarr.port;
    user = props.common_config.arr_user_props.user.name;
  };

  sops = {
    age.keyFile = "/etc/sonarr/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      sonarr-api-key-ev = {
        sopsFile = ../../secrets/sonarr-api-key-ev;
      };
    };
  };
}
