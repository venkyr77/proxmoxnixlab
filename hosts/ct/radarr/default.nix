{
  config,
  props,
  ...
}: {
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  boot.supportedFilesystems = ["nfs"];

  fileSystems."/mnt/sabnzbd" = {
    device = "${props.cts.sabnzbd.ipv4_short}:/export/sabnzbd";
    fsType = "nfs";
  };

  services.radarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.radarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.radarr-api-key-ev.sopsFile = ./secrets/radarr-api-key-ev;
}
