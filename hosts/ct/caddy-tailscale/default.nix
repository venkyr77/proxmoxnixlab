{
  config,
  nodes,
  pkgs,
  props,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy = {
    enable = true;
    environmentFile = "${config.sops.secrets.caddy-ev.path}";
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      email {env.CLOUDFLARE_EMAIL}
    '';
    package = pkgs.caddy.withPlugins {
      hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
    };
    virtualHosts = {
      "grafana.euls.dev".extraConfig = ''
        reverse_proxy ${props.cts.monitor.ipv4_short}:${toString nodes.monitor.config.services.grafana.settings.server.http_port}
      '';
    };
  };

  sops.secrets.caddy-ev.sopsFile = ./secrets/caddy-ev;
}
