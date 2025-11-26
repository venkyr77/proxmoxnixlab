{name, ...}: {
  imports = [
    ./configarr
    ./jellarr
  ];

  users = {
    groups.${name}.gid = 210;
    users.${name} = {
      group = name;
      isSystemUser = true;
      uid = 210;
    };
  };
}
