{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.sabnzbd;
in {
  imports = [
    ../../../modules/users/mediarr.nix
  ];

  options.services.sabnzbd.port = pkgs.lib.mkOption {
    default = 8082;
    type = pkgs.lib.types.int;
  };

  config = {
    mediarr.make_user = true;

    networking.firewall.allowedTCPPorts = [cfg.port];

    services.sabnzbd = {
      enable = true;
      group = "mediarr";
      user = "mediarr";
    };

    systemd = {
      services = {
        sabnzbd.serviceConfig.ExecStart =
          pkgs.lib.mkForce
          "${pkgs.lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile} -s 0.0.0.0:${toString cfg.port}";

        sabnzbd-config-maker = {
          after = ["sabnzbd.service"];
          path = with pkgs; [coreutils gnused systemd];
          script =
            #sh
            ''
              sleep 5
              systemctl stop sabnzbd.service
              sed -i 's/^host_whitelist\s*=.*/host_whitelist = sabnzbd.euls.dev,/' ${cfg.configFile}
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
  };
}
