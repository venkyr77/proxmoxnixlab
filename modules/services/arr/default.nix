{props, ...}: let
  inherit (props.common_config) arr_user_props;
in {
  imports = [
    ./radarr
    ./recyclarr
    ./sabnzbd
    ./sonarr
  ];
  users = {
    groups.${arr_user_props.group.name} = {
      gid = arr_user_props.group.id;
    };
    users.${arr_user_props.user.name} = {
      group = arr_user_props.group.name;
      isSystemUser = true;
      uid = arr_user_props.user.id;
    };
  };
}
