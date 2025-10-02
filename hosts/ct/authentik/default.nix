{config, ...}: {
  networking.firewall.allowedTCPPorts = [
    9000
    9443
  ];

  services.authentik = {
    enable = true;
    environmentFile = "${config.sops.secrets.authentik-ev.path}";
    settings = {
      authentik_host = "https://auth.euls.dev";
      avatars = "initials";
      disable_startup_analytics = true;
    };
  };

  sops.secrets.authentik-ev.sopsFile = ./secrets/authentik-ev;
}
