{config, ...}: {
  services = {
    prometheus.exporters.unbound = {
      enable = true;
      openFirewall = true;
      unbound = {
        ca = null;
        certificate = null;
        host = "unix://${config.services.unbound.settings.remote-control.control-interface}";
        key = null;
      };
    };

    unbound = {
      enable = true;
      settings = {
        remote-control = {
          control-enable = true;
          control-interface = "/var/lib/unbound/unbound.ctl";
        };
        server = {
          access-control = ["10.0.0.0/24 allow"];
          edns-buffer-size = 1232;
          extended-statistics = true;
          harden-dnssec-stripped = true;
          harden-glue = true;
          interface = ["0.0.0.0"];
          port = 53;
          prefetch = true;
          use-caps-for-id = false;
        };
      };
    };
  };
}
