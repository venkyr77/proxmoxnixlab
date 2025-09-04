{
  common_config = {
    arr_user_props = {
      group = {
        id = 210;
        name = "mediarr";
      };
      user = {
        id = 210;
        name = "mediarr";
      };
    };
    authorized_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKq26n2TKyJF/LSKXTjRHlCS1rG4+P/cQkG8dBufDkh venkyrocker7777@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlTUXrGWkLvAxORPsjc4mCkBNr1jtKJoJh6fNoj8zYj venkyrocker7777@gmail.com"
    ];
    services = {
      grafana.settings.server.http_port = 3000;
      prometheus = {
        exporters.node.port = 9100;
        port = 9090;
      };
      radarr.port = 7878;
      sonarr.port = 8989;
      sabnzbd.port = 8080;
    };
  };
  vms = {
    collapse = {
      cpu_cores = 2;
      cpu_host_type = "host";
      disk_size = 64;
      hostpci = null;
      ipv4_full = "10.0.0.100/24";
      ipv4_short = "10.0.0.100";
      memory = 4 * 1024;
      vm_id = 100;
    };
    jerax = {
      cpu_cores = 2;
      cpu_host_type = "host";
      disk_size = 64;
      hostpci = null;
      ipv4_full = "10.0.0.101/24";
      ipv4_short = "10.0.0.101";
      memory = 4 * 1024;
      vm_id = 101;
    };
    miracle = {
      cpu_cores = 16;
      cpu_host_type = "host";
      disk_size = 64;
      hostpci = {
        device = "hostpci0";
        id = "0000:01:00";
        pcie = true;
        rombar = true;
        xvga = true;
      };
      ipv4_full = "10.0.0.102/24";
      ipv4_short = "10.0.0.102";
      memory = 16 * 1024;
      vm_id = 102;
    };
    topson = {
      cpu_cores = 2;
      cpu_host_type = "host";
      disk_size = 512;
      hostpci = null;
      ipv4_full = "10.0.0.103/24";
      ipv4_short = "10.0.0.103";
      memory = 8 * 1024;
      vm_id = 103;
    };
  };
}
