{
  config,
  lib,
  name,
  nodes,
  pkgs,
  props,
  ...
}: {
  imports = [
    (
      import ../psql-shifter.nix {
        arr = "lidarr";
        inherit config lib nodes pkgs props;
      }
    )
  ];

  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.lidarr-api-key-ev.path}"
    ];
    group = name;
    openFirewall = true;
    user = name;
  };

  sops = {
    secrets.lidarr-api-key.sopsFile = ../../../../secrets/lidarr-api-key;
    templates.lidarr-api-key-ev = {
      content = ''
        LIDARR__AUTH__APIKEY=${config.sops.placeholder.lidarr-api-key}
      '';
      group = name;
      owner = name;
    };
  };
}
