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
    angel = {
      cpu_cores = 4;
      disk_size = 16;
      ipv4_full = "10.0.0.70/24";
      ipv4_short = "10.0.0.70";
      memory = 4 * 1024;
      mount_point = null;
      need_sops_pk = false;
      need_igpu_patch = false;
      need_ts_patch = true;
      vm_id = 150;
    };
    auth-n-pass = {
      cpu_cores = 8;
      disk_size = 16;
      ipv4_full = "10.0.0.71/24";
      ipv4_short = "10.0.0.71";
      memory = 8 * 1024;
      mount_point = null;
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = false;
      vm_id = 151;
    };
    configarr = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.72/24";
      ipv4_short = "10.0.0.72";
      memory = 4 * 1024;
      mount_point = null;
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = false;
      vm_id = 152;
    };
    dns = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.73/24";
      ipv4_short = "10.0.0.73";
      memory = 2 * 1024;
      mount_point = null;
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = true;
      tailscale_ip = "100.77.0.100";
      vm_id = 153;
    };
    fetcharr = {
      cpu_cores = 16;
      disk_size = 16;
      ipv4_full = "10.0.0.74/24";
      ipv4_short = "10.0.0.74";
      memory = 8 * 1024;
      mount_point = [
        (attachHostDatasetMP "sabnzbd")
        (attachProxyMP "/mnt/movies")
        (attachProxyMP "/mnt/music")
        (attachProxyMP "/mnt/shows")
      ];
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = false;
      vm_id = 154;
    };
    reverse-proxy = {
      cpu_cores = 2;
      disk_size = 16;
      ipv4_full = "10.0.0.75/24";
      ipv4_short = "10.0.0.75";
      memory = 2 * 1024;
      mount_point = null;
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = true;
      tailscale_ip = "100.77.0.101";
      vm_id = 155;
    };
    services = {
      cpu_cores = 4;
      disk_size = 16;
      ipv4_full = "10.0.0.76/24";
      ipv4_short = "10.0.0.76";
      memory = 4 * 1024;
      mount_point = null;
      need_sops_pk = true;
      need_igpu_patch = false;
      need_ts_patch = false;
      vm_id = 156;
    };
    streamarr = {
      cpu_cores = 8;
      disk_size = 64;
      ipv4_full = "10.0.0.77/24";
      ipv4_short = "10.0.0.77";
      memory = 24 * 1024;
      mount_point = [
        (attachHostDatasetMP "jellyfin")
        (attachHostDatasetMP "sabnzbd")
        (attachProxyMP "/mnt/movies")
        (attachProxyMP "/mnt/music")
        (attachProxyMP "/mnt/shows")
      ];
      need_sops_pk = true;
      need_igpu_patch = true;
      need_ts_patch = false;
      vm_id = 157;
    };
  };
}
