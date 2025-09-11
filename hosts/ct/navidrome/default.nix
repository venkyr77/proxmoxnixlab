{
  services.navidrome = {
    enable = true;
    group = "mediarr";
    openFirewall = true;
    settings.Address = "0.0.0.0";
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
