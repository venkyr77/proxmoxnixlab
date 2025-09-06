{config, ...}: {
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.radarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.radarr-api-key-ev.sopsFile = ./secrets/radarr-api-key-ev;
}
