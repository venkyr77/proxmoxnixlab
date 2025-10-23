let
  attachHostDatasetMP = host: {
    acl = true;
    path = "/mnt/${host}-data";
    volume = "/tank/${host}-data";
  };
  attachProxyMP = path: {
    acl = true;
    inherit path;
    volume = path;
  };
in {
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
    authentik = {
      cpu_cores = 8;
      disk_size = 16;
      ipv4_full = "10.0.0.71/24";
      ipv4_short = "10.0.0.71";
      memory = 8 * 1024;
      mount_point = null;
      vm_id = 151;
    };
    caddy-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.72/24";
      ipv4_short = "10.0.0.72";
      memory = 1 * 1024;
      mount_point = null;
      tailscale_ip = "100.77.0.102";
      vm_id = 152;
    };
    gatus-tailscale = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.74/24";
      ipv4_short = "10.0.0.74";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 154;
    };
    grafana = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.75/24";
      ipv4_short = "10.0.0.75";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 155;
    };
    homepage = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.76/24";
      ipv4_short = "10.0.0.76";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 156;
    };
    mediarr = {
      cpu_cores = 8;
      disk_size = 64;
      ipv4_full = "10.0.0.78/24";
      ipv4_short = "10.0.0.78";
      memory = 24 * 1024;
      mount_point = [
        (attachHostDatasetMP "jellyfin")
        (attachHostDatasetMP "sabnzbd")
        (attachProxyMP "/mnt/movies")
        (attachProxyMP "/mnt/music")
        (attachProxyMP "/mnt/shows")
      ];
      vm_id = 158;
    };
    prometheus-server = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.80/24";
      ipv4_short = "10.0.0.80";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 160;
    };
    searx = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.84/24";
      ipv4_short = "10.0.0.84";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 164;
    };
    unbound = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.86/24";
      ipv4_short = "10.0.0.86";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 166;
    };
    vaultwarden = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.87/24";
      ipv4_short = "10.0.0.87";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 167;
    };
    ntfy-sh = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.88/24";
      ipv4_short = "10.0.0.88";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 168;
    };
    memos = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.89/24";
      ipv4_short = "10.0.0.89";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 169;
    };
    linkwarden = {
      cpu_cores = 1;
      disk_size = 16;
      ipv4_full = "10.0.0.90/24";
      ipv4_short = "10.0.0.90";
      memory = 1 * 1024;
      mount_point = null;
      vm_id = 170;
    };
  };
}
