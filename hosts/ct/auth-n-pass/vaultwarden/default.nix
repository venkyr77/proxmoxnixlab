{config, ...}: {
  networking.firewall.allowedTCPPorts = [config.services.vaultwarden.config.ROCKET_PORT];

  services.vaultwarden = {
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
    enable = true;
  };
}
