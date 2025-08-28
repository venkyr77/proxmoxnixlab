{
  miracle = {
    cpu_cores = 16;
    cpu_host_type = "host";
    disk_size = 256;
    hostpci = {
      device = "hostpci0";
      id = "0000:01:00.0";
      pcie = true;
      rombar = true;
      xvga = true;
    };
    ipv4_full = "10.0.0.100/24";
    ipv4_short = "10.0.0.100";
    memory = 64 * 1024;
    vm_id = 100;
  };
}
