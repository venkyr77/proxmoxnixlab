{
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
    adg = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.151/24";
      ipv4_short = "10.0.0.151";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 151;
    };
    monitor = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.152/24";
      ipv4_short = "10.0.0.152";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 152;
    };
    caddy-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.153/24";
      ipv4_short = "10.0.0.153";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 153;
    };
    radarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.154/24";
      ipv4_short = "10.0.0.154";
      memory = 1 * 1024;
      mount_point = {
        path = "/mnt/movies";
        volume = "/mnt/movies";
      };
      vm_id = 154;
    };
    sonarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.155/24";
      ipv4_short = "10.0.0.155";
      memory = 1 * 1024;
      mount_point = {
        path = "/mnt/shows";
        volume = "/mnt/shows";
      };
      vm_id = 155;
    };
    prowlarr = {
      cpu_cores = 1;
      disk_size = 8;
      ipv4_full = "10.0.0.156/24";
      ipv4_short = "10.0.0.156";
      memory = 0.5 * 1024;
      mount_point = null;
      vm_id = 156;
    };
    recyclarr = {
      cpu_cores = 1;
      disk_size = 8;
      ipv4_full = "10.0.0.157/24";
      ipv4_short = "10.0.0.157";
      memory = 0.5 * 1024;
      mount_point = null;
      vm_id = 157;
    };
    lidarr = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.159/24";
      ipv4_short = "10.0.0.159";
      memory = 1 * 1024;
      mount_point = {
        path = "/mnt/songs";
        volume = "/mnt/songs";
      };
      vm_id = 159;
    };
    navidrome = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.160/24";
      ipv4_short = "10.0.0.160";
      memory = 1 * 1024;
      mount_point = {
        path = "/mnt/songs";
        volume = "/mnt/songs";
      };
      vm_id = 160;
    };
    searx = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.161/24";
      ipv4_short = "10.0.0.161";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 161;
    };
    sabnzbd = {
      cpu_cores = 2;
      disk_size = 512;
      ipv4_full = "10.0.0.162/24";
      ipv4_short = "10.0.0.162";
      memory = 4 * 1024;
      mount_point = {
        path = "/mnt/sabnzbd";
        volume = "/export/sabnzbd";
      };
      vm_id = 162;
    };
  };
}
