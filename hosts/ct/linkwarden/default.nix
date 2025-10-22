{config, ...}: {
  services.linkwarden = {
    enable = true;
    enableRegistration = true;
    environmentFile = config.sops.secrets.linkwarden-ev.path;
    host = "0.0.0.0";
    openFirewall = true;
    port = 8080;
  };

  sops.secrets.linkwarden-ev.sopsFile = ./secrets/linkwarden-ev;
}
