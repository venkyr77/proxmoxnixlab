{
  config,
  name,
  pkgs,
  ...
}: let
  cfg = config.services.sabnzbd;
in {
  options.services.sabnzbd.port = pkgs.lib.mkOption {
    default = 8082;
    type = pkgs.lib.types.int;
  };

  config = {
    networking.firewall.allowedTCPPorts = [cfg.port];

    services.sabnzbd = {
      configFile = "/mnt/sabnzbd-data/sabnzbd.ini";
      enable = true;
      group = name;
      user = name;
    };

    sops = {
      secrets = {
        sabnzbd-api-key.sopsFile = ../../../../secrets/sabnzbd-api-key;
        sabnzbd-eweka-creds.sopsFile = ../../../../secrets/sabnzbd-eweka-creds;
      };
      templates.sabnzbd-config = {
        content = import ./config.nix {inherit config;};
        group = name;
        owner = name;
      };
    };

    systemd.services = {
      sabnzbd = {
        preStart =
          # sh
          ''
            set -euo pipefail

            mkdir -p "$(dirname ${cfg.configFile})"
            chmod u+w "${cfg.configFile}" 2>/dev/null || true

            cat "${config.sops.templates.sabnzbd-config.path}" > "${cfg.configFile}"

            chown ${cfg.user}:${cfg.group} "${cfg.configFile}"
            chmod 0640 "${cfg.configFile}"
          '';
        serviceConfig.ExecStart =
          pkgs.lib.mkForce
          "${pkgs.lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile} -s 0.0.0.0:${toString cfg.port}";
      };
    };
  };
}
