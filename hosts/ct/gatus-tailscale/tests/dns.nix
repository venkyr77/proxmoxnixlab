{props, ...}: {
  services.gatus.settings.endpoints =
    map (endpoint_conf:
      endpoint_conf
      // {
        group = "dns";
      })
    [
      {
        conditions = [
          "[BODY] == any(8.8.8.8,8.8.4.4)"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "dns.google.";
          query-type = "A";
        };
        interval = "1m";
        name = "[UNBOUND] - dns.google";
        url = "${props.cts.unbound.ipv4_short}";
      }
      {
        conditions = [
          "[BODY] == any(9.9.9.9,149.112.112.112)"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "dns.quad9.net.";
          query-type = "A";
        };
        interval = "1m";
        name = "[UNBOUND] - dns.quad9.net";
        url = "${props.cts.unbound.ipv4_short}";
      }
      {
        conditions = [
          "[BODY] == any(8.8.8.8,8.8.4.4)"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "dns.google.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG] - dns.google";
        url = "${props.cts.adg-tailscale.ipv4_short}";
      }
      {
        conditions = [
          "[BODY] == any(9.9.9.9,149.112.112.112)"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "dns.quad9.net.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG] - dns.quad9.net";
        url = "${props.cts.adg-tailscale.ipv4_short}";
      }
      {
        conditions = [
          "has([BODY]) == false"
          "[DNS_RCODE] == NXDOMAIN"
        ];
        dns = {
          query-name = "test.euls.dev.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG][LOCAL] - test.euls.dev";
        url = "${props.cts.adg-tailscale.ipv4_short}";
      }
      {
        conditions = [
          "has([BODY]) == false"
          "[DNS_RCODE] == NXDOMAIN"
        ];
        dns = {
          query-name = "test.euls.dev.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG][TAILSCALE] - test.euls.dev";
        url = "${props.cts.adg-tailscale.tailscale_ip}";
      }
      {
        conditions = [
          "[BODY] == ${props.cts.caddy-tailscale.ipv4_short}"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "searx.euls.dev.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG][LOCAL] - searx.euls.dev";
        url = "${props.cts.adg-tailscale.ipv4_short}";
      }
      {
        conditions = [
          "[BODY] == ${props.cts.caddy-tailscale.tailscale_ip}"
          "[DNS_RCODE] == NOERROR"
        ];
        dns = {
          query-name = "searx.euls.dev.";
          query-type = "A";
        };
        interval = "1m";
        name = "[ADG][TAILSCALE] - searx.euls.dev";
        url = "${props.cts.adg-tailscale.tailscale_ip}";
      }
    ];
}
