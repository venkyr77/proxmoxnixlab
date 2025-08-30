{
  common_config = {
    services = {
      grafana.settings.server.http_port = 3000;
      prometheus = {
        exporters.node.port = 9100;
        port = 9090;
      };
    };
  };
  vms = {
    miracle = {
      cpu_cores = 16;
      cpu_host_type = "host";
      disk_size = 256;
      hostpci = {
        device = "hostpci0";
        id = "0000:01:00";
        pcie = true;
        rombar = true;
        xvga = true;
      };
      ipv4_full = "10.0.0.100/24";
      ipv4_short = "10.0.0.100";
      memory = 64 * 1024;
      vm_id = 100;
    };
    monitor = {
      cpu_cores = 2;
      cpu_host_type = "host";
      disk_size = 64;
      hostpci = null;
      ipv4_full = "10.0.0.101/24";
      ipv4_short = "10.0.0.101";
      memory = 4 * 1024;
      vm_id = 101;
    };
  };
}
