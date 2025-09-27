{
  cts = {
    adg-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.70/24";
      ipv4_short = "10.0.0.70";
      memory = 1 * 1024;
      mount_point = null;
      tailscale_ip = "100.77.0.100";
      vm_id = 150;
    };
    caddy-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.71/24";
      ipv4_short = "10.0.0.71";
      memory = 1 * 1024;
      mount_point = null;
      tailscale_ip = "100.77.0.101";
      vm_id = 151;
    };
    configarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.72/24";
      ipv4_short = "10.0.0.72";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 152;
    };
    grafana = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.73/24";
      ipv4_short = "10.0.0.73";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 153;
    };
    homepage = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.74/24";
      ipv4_short = "10.0.0.74";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 154;
    };
    lidarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.75/24";
      ipv4_short = "10.0.0.75";
      memory = 2 * 1024;
      mount_point = {
        path = "/var/lib/sabnzbd";
        volume = "/tank/sabnzbd";
      };
      vm_id = 155;
    };
    navidrome = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.76/24";
      ipv4_short = "10.0.0.76";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 156;
    };
    prometheus-server = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.77/24";
      ipv4_short = "10.0.0.77";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 157;
    };
    prowlarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.78/24";
      ipv4_short = "10.0.0.78";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 158;
    };
    radarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.79/24";
      ipv4_short = "10.0.0.79";
      memory = 2 * 1024;
      mount_point = {
        path = "/var/lib/sabnzbd";
        volume = "/tank/sabnzbd";
      };
      vm_id = 159;
    };
    sabnzbd = {
      cpu_cores = 4;
      disk_size = 128;
      ipv4_full = "10.0.0.80/24";
      ipv4_short = "10.0.0.80";
      memory = 4 * 1024;
      mount_point = {
        path = "/var/lib/sabnzbd";
        volume = "/tank/sabnzbd";
      };
      vm_id = 160;
    };
    searx = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.81/24";
      ipv4_short = "10.0.0.81";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 161;
    };
    sonarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.82/24";
      ipv4_short = "10.0.0.82";
      memory = 2 * 1024;
      mount_point = {
        path = "/var/lib/sabnzbd";
        volume = "/tank/sabnzbd";
      };
      vm_id = 162;
    };
    unbound = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.83/24";
      ipv4_short = "10.0.0.83";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 163;
    };
    uptime-kuma = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.84/24";
      ipv4_short = "10.0.0.84";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 164;
    };
    vaultwarden = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.85/24";
      ipv4_short = "10.0.0.85";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 165;
    };
    gatus = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.86/24";
      ipv4_short = "10.0.0.86";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 166;
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
