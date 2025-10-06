{
  config,
  lib,
  ...
}: let
  cfg = config.mediarr;
in {
  options.mediarr = {
    make_user = lib.mkEnableOption "add mediarr system user";
    user_gid = lib.mkOption {
      default = 210;
      type = lib.types.int;
    };
    user_uid = lib.mkOption {
      default = 210;
      type = lib.types.int;
    };
  };
  config.users = {
    groups.mediarr.gid = cfg.user_gid;
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = cfg.user_uid;
    };
  };
}
