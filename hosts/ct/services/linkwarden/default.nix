{config, ...}: {
  services.linkwarden = {
    enable = true;
    enableRegistration = true;
    environmentFile = config.sops.secrets.linkwarden-ev.path;
    host = "0.0.0.0";
    openFirewall = true;
    port = 5050;
  };

  sops.secrets.linkwarden-ev.sopsFile = ../../../../secrets/linkwarden-ev;
}
