{
  config,
  props,
  ...
}: {
  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.radarr-api-key-ev.path}"
    ];
    group = props.common_config.arr_user_props.group.name;
    openFirewall = true;
    settings.server.port = props.common_config.services.radarr.port;
    user = props.common_config.arr_user_props.user.name;
  };
}
