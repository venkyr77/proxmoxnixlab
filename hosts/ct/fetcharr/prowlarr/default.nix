{
  config,
  lib,
  nodes,
  pkgs,
  props,
  ...
}: {
  imports = [
    (import ../config-maker {
      arr = "prowlarr";
      inherit config pkgs;
      script =
        # sh
        ''
          set -euo pipefail

          ${import ../psql-shift-script.nix {
            arr = "prowlarr";
            inherit config lib nodes props;
          }}
        '';
    })
  ];

  services.prowlarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.templates.prowlarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops = {
    secrets.prowlarr-api-key.sopsFile = ../../../../secrets/prowlarr-api-key;
    templates.prowlarr-api-key-ev = {
      content = ''
        PROWLARR__AUTH__APIKEY=${config.sops.placeholder.prowlarr-api-key}
      '';
      group = "root";
      owner = "root";
    };
  };
}
