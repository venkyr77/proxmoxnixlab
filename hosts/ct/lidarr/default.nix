{config, ...}: {
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.lidarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.lidarr-api-key-ev.sopsFile = ./secrets/lidarr-api-key-ev;
}
