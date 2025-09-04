{
  config,
  pkgs,
  props,
  ...
}: let
  inherit (props.common_config) arr_user_props;
  cfg = config.services.sabnzbd;
in {
  networking.firewall.allowedTCPPorts = [props.common_config.services.sabnzbd.port];

  services.sabnzbd = {
    enable = true;
    group = arr_user_props.group.name;
    user = arr_user_props.user.name;
  };

  systemd.services = {
    sabnzbd.serviceConfig.ExecStart =
      pkgs.lib.mkForce
      "${pkgs.lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile} -s 0.0.0.0:${toString props.common_config.services.sabnzbd.port}";
    sabnzbd-config-maker = {
      after = ["sabnzbd.service"];
      path = with pkgs; [coreutils gnused systemd];
      script =
        #sh
        ''
          sleep 5
          sed -i 's/^host_whitelist\s*=.*/host_whitelist = sabnzbd.euls.dev,/' ${cfg.configFile}
          systemctl restart sabnzbd.service
        '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
