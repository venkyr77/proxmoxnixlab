{
  cts = {
    adg = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.70/24";
      ipv4_short = "10.0.0.70";
      memory = 1 * 1024;
      vm_id = 150;
    };
    caddy-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.71/24";
      ipv4_short = "10.0.0.71";
      memory = 1 * 1024;
      vm_id = 151;
    };
    lidarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.72/24";
      ipv4_short = "10.0.0.72";
      memory = 1 * 1024;
      vm_id = 152;
    };
    monitor = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.73/24";
      ipv4_short = "10.0.0.73";
      memory = 1 * 1024;
      vm_id = 153;
    };
    navidrome = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.74/24";
      ipv4_short = "10.0.0.74";
      memory = 1 * 1024;
      vm_id = 154;
    };
    prowlarr = {
      cpu_cores = 1;
      disk_size = 8;
      ipv4_full = "10.0.0.75/24";
      ipv4_short = "10.0.0.75";
      memory = 0.5 * 1024;
      vm_id = 155;
    };
    radarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.76/24";
      ipv4_short = "10.0.0.76";
      memory = 1 * 1024;
      vm_id = 156;
    };
    recyclarr = {
      cpu_cores = 1;
      disk_size = 8;
      ipv4_full = "10.0.0.77/24";
      ipv4_short = "10.0.0.77";
      memory = 0.5 * 1024;
      vm_id = 157;
    };
    sabnzbd = {
      cpu_cores = 2;
      disk_size = 512;
      ipv4_full = "10.0.0.78/24";
      ipv4_short = "10.0.0.78";
      memory = 4 * 1024;
      vm_id = 158;
    };
    searx = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.79/24";
      ipv4_short = "10.0.0.79";
      memory = 1 * 1024;
      vm_id = 159;
    };
    sonarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.80/24";
      ipv4_short = "10.0.0.80";
      memory = 1 * 1024;
      vm_id = 160;
    };
    unbound = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.81/24";
      ipv4_short = "10.0.0.81";
      memory = 1 * 1024;
      vm_id = 161;
    };
  };

  vms = {
    gpubox = {
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
      ipv4_full = "10.0.0.101/24";
      ipv4_short = "10.0.0.101";
      memory = 16 * 1024;
      vm_id = 101;
    };
  };
}
