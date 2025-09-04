{props, ...}: {
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services = {
    resolved.enable = false;
    unbound = {
      enable = true;
      settings.server = {
        access-control = ["10.0.0.0/24 allow"];
        edns-buffer-size = 1232;
        harden-dnssec-stripped = true;
        harden-glue = true;
        interface = ["0.0.0.0"];
        local-data = [''"euls.dev. A ${props.vms.collapse.ipv4_short}"''];
        local-zone = [''"euls.dev." redirect''];
        port = 53;
        prefetch = true;
        use-caps-for-id = false;
      };
    };
  };
}
