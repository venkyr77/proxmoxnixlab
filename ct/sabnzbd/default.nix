{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.sabnzbd;
in {
  services.sabnzbd = {
    enable = true;
    group = "mediarr";
    openFirewall = true;
    user = "mediarr";
  };

  systemd.services = {
    sabnzbd.serviceConfig.ExecStart =
      pkgs.lib.mkForce
      "${pkgs.lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile} -s 0.0.0.0:8080";
    sabnzbd-config-maker = {
      after = ["sabnzbd.service"];
      path = with pkgs; [coreutils gnused systemd];
      script =
        #sh
        ''
          sleep 5
          sed -i 's/^host_whitelist\s*=.*/host_whitelist = sabnzbd.euls.dev,/' /var/lib/sabnzbd/sabnzbd.ini
          systemctl restart sabnzbd.service
        '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  users = {
    groups.mediarr = {
      gid = 210;
    };
    users.mediarr = {
      group = "mediarr";
      isSystemUser = true;
      uid = 210;
    };
  };
}
