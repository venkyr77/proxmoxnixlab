{
  config,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [(lib.toInt config.services.uptime-kuma.settings.PORT)];

  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = "4000";
    };
  };
}
