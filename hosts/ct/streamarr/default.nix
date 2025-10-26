{
  inputs,
  name,
  ...
}: {
  imports = [
    inputs.declarative-jellyfin.nixosModules.default
    ./jellyfin
    ./navidrome
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
