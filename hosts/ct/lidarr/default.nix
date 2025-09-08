{
  config,
  props,
  ...
}: {
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  fileSystems."/mnt/sabnzbd" = {
    device = "${props.cts.sabnzbd.ipv4_short}:/export/sabnzbd";
    fsType = "nfs";
  };

  services.lidarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.lidarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.lidarr-api-key-ev.sopsFile = ./secrets/lidarr-api-key-ev;
}
