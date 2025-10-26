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

    sops.secrets = {
      sabnzbd-api-key.sopsFile = ../../../../secrets/sabnzbd-api-key;
      sabnzbd-eweka-creds.sopsFile = ../../../../secrets/sabnzbd-eweka-creds;
    };

    systemd.services = {
      sabnzbd.serviceConfig.ExecStart =
        pkgs.lib.mkForce
        "${pkgs.lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile} -s 0.0.0.0:${toString cfg.port}";

      sabnzbd-config-maker = {
        after = ["sabnzbd.service"];
        path = with pkgs; [coreutils gnused systemd];
        script =
          #sh
          ''
            for i in $(seq 1 30); do
              [ -f "${cfg.configFile}" ] && break
              sleep 1
            done

            systemctl stop sabnzbd.service

            sed -i 's/^host_whitelist\s*=.*/host_whitelist = sabnzbd.euls.dev,/' ${cfg.configFile}

            key="$(< ${config.sops.secrets.sabnzbd-api-key.path})"
            sed -i "s/^api_key\s*=.*/api_key = ''${key}/" ${cfg.configFile}

            if ! grep -q '^\[\[news\.eweka\.nl\]\]' ${cfg.configFile}; then
              cat >> "${cfg.configFile}" <<SERVER
            [servers]
            [[news.eweka.nl]]
            name = news.eweka.nl
            displayname = news.eweka.nl
            host = news.eweka.nl
            port = 563
            timeout = 60
            $(< ${config.sops.secrets.sabnzbd-eweka-creds.path})
            connections = 50
            ssl = 1
            ssl_verify = 2
            ssl_ciphers = ""
            enable = 1
            required = 0
            optional = 0
            retention = 0
            expire_date = ""
            quota = ""
            usage_at_start = 0
            priority = 0
            notes = ""
            SERVER
            fi

            if ! grep -q '^\[\[music\]\]' ${cfg.configFile}; then
              sed -i '/^\[\[software\]\]/i\
            [[music]]\
            name = music\
            order = 5\
            pp = ""\
            script = Default\
            dir = ""\
            newzbin = ""\
            priority = -100
            ' ${cfg.configFile}
            fi

            systemctl start sabnzbd.service
          '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  };
}
