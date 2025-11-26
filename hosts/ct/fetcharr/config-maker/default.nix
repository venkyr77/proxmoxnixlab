{
  arr,
  config,
  pkgs,
  script,
  ...
}: {
  systemd.services."${arr}-config-maker" = {
    after = ["${arr}.service"];
    path = [
      pkgs.coreutils
      pkgs.sqlite
      pkgs.systemd
      pkgs.xmlstarlet
    ];
    inherit script;
    serviceConfig = {
      EnvironmentFile = config.sops.templates.fetcharr-db-pass-ev.path;
      Type = "oneshot";
      User = "root";
    };
    wantedBy = ["multi-user.target"];
  };
}
