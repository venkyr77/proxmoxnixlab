{props, ...}: {
  imports = [
    ../../modules/services/mediarr.nix
  ];

  services.radarr = {
    enable = true;
    group = props.common_config.arr_user_props.group.name;
    openFirewall = true;
    user = props.common_config.arr_user_props.user.name;
  };
}
