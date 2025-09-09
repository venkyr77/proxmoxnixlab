{
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
        local-data =
          map (service: ''"${service}.euls.dev. A 100.77.0.100"'')
          [
            "adg"
            "grafana"
            "jellyfin"
            "lidarr"
            "navidrome"
            "prometheus"
            "prowlarr"
            "radarr"
            "sabnzbd"
            "searx"
            "sonarr"
          ];
        local-zone = [''"euls.dev." transparent''];
        port = 53;
        prefetch = true;
        use-caps-for-id = false;
      };
    };
  };
}
