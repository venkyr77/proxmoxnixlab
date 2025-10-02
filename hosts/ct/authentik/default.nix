{config, ...}: {
  networking.firewall.allowedTCPPorts = [9000 9443];

  services.authentik = {
    enable = true;
    environmentFile = "${config.sops.secrets.authentik-ev.path}";
    settings = {
      disable_startup_analytics = true;
      avatars = "initials";
      authentik_host = "https://auth.euls.dev";
    };
  };

  sops.secrets.authentik-ev.sopsFile = ./secrets/authentik-ev;
}
