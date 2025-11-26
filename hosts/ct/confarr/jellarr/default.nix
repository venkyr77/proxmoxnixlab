{
  config,
  inputs,
  name,
  ...
}: {
  imports = [
    inputs.jellarr.nixosModules.default
    ./config.nix
  ];

  services.jellarr = {
    environmentFile = config.sops.templates.jellarr-ev.path;
    enable = true;
    group = name;
    user = name;
  };

  sops = {
    secrets = {
      jellarr-api-key.sopsFile = ../../../../secrets/jellarr-api-key;
      jellyfin-admin-pass = {
        sopsFile = ../../../../secrets/jellyfin-admin-pass;
        inherit (config.services.jellarr) group;
        owner = config.services.jellarr.user;
      };
    };
    templates.jellarr-ev = {
      content = ''
        JELLARR_API_KEY=${config.sops.placeholder.jellarr-api-key}
      '';
      inherit (config.services.jellarr) group;
      owner = config.services.jellarr.user;
    };
  };
}
