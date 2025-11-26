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
    (import ../config-maker {
      arr = "sonarr";
      inherit config pkgs;
      script =
        # sh
        ''
          set -euo pipefail

          ${import ../psql-shift-script.nix {
            arr = "sonarr";
            inherit config lib nodes props;
          }}
        '';
    })
  ];
  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.sonarr-api-key-ev.path}"
    ];
    group = name;
    openFirewall = true;
    user = name;
  };

  sops = {
    secrets.sonarr-api-key.sopsFile = ../../../../secrets/sonarr-api-key;
    templates.sonarr-api-key-ev = {
      content = ''
        SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}
      '';
      group = name;
      owner = name;
    };
  };
}
