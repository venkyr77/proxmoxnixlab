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
        arr = "radarr";
        inherit config lib nodes pkgs props;
      }
    )
  ];

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.radarr-api-key-ev.path}"
    ];
    group = name;
    openFirewall = true;
    user = name;
  };

  sops = {
    secrets.radarr-api-key.sopsFile = ../../../../secrets/radarr-api-key;
    templates.radarr-api-key-ev = {
      content = ''
        RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}
      '';
      group = name;
      owner = name;
    };
  };
}
