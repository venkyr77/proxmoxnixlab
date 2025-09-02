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
      sabnzbd.port = 8080;
    };
  };
  cts = {
    unbound = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.150/24";
      ipv4_short = "10.0.0.150";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 150;
    };
    caddy-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.151/24";
      ipv4_short = "10.0.0.151";
      memory = 2 * 1024;
      mount_point = null;
      vm_id = 151;
    };
    sabnzbd = {
      cpu_cores = 2;
      disk_size = 256;
      ipv4_full = "10.0.0.152/24";
      ipv4_short = "10.0.0.152";
      memory = 8 * 1024;
      mount_point = [
        {
          path = "/mnt/sabnzbd";
          volume = "/share/sabnzbd";
        }
      ];
      vm_id = 152;
    };
    radarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.153/24";
      ipv4_short = "10.0.0.153";
      memory = 2 * 1024;
      mount_point = [
        {
          path = "/mnt/sabnzbd";
          volume = "/share/sabnzbd";
        }
      ];
      vm_id = 153;
    };
    recyclarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.154/24";
      ipv4_short = "10.0.0.154";
      memory = 2 * 1024;
      mount_point = null;
      vm_id = 154;
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
