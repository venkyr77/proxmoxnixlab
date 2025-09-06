{config, ...}: {
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.sonarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.sonarr-api-key-ev.sopsFile = ./secrets/sonarr-api-key-ev;
}
