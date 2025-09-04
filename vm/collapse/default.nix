{
  imports = [
    ../../modules/services/caddy.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/unbound.nix
  ];

  sops = {
    age.keyFile = "/etc/collapse/sopspk";
    defaultSopsFormat = "binary";
    secrets = {
      caddy = {
        sopsFile = ../../secrets/caddy;
      };
    };
  };
}
