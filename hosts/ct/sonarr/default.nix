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

  services.sonarr = {
    enable = true;
    environmentFiles = [
      "${config.sops.secrets.sonarr-api-key-ev.path}"
    ];
    openFirewall = true;
  };

  sops.secrets.sonarr-api-key-ev.sopsFile = ./secrets/sonarr-api-key-ev;
}
