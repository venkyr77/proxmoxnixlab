{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;
    environmentFile = "${config.sops.secrets.caddy.path}";
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      email {env.CLOUDFLARE_EMAIL}
    '';
    package = pkgs.caddy.withPlugins {
      hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
    };
    virtualHosts = {
    };
  };
}
