{name, ...}: {
  services.${name} = {
    group = "mediarr";
    user = "mediarr";
  };

  users = {
    groups.mediarr.gid = 210;
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = 210;
    };
  };
}
