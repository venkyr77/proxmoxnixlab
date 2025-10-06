{
  lib,
  props,
  ...
}: let
  mkCT = {
    cpu_cores,
    disk_size,
    ipv4_full,
    memory,
    mount_point,
    vm_id,
    vm_name,
  }: {
    cpu.cores = cpu_cores;
    depends_on = ["proxmox_virtual_environment_file.nixostar"];
    disk = {
      datastore_id = "local-lvm";
      size = disk_size;
    };
    features.nesting = true;
    initialization = {
      hostname = vm_name;
      ip_config.ipv4 = {
        address = "${ipv4_full}";
        gateway = "10.0.0.1";
      };
    };
    memory.dedicated = memory;
    inherit mount_point;
    network_interface = {
      bridge = "vmbr0";
      name = "veth0";
    };
    node_name = "pve";
    operating_system = {
      template_file_id = "local:vztmpl/nixos.tar.xz";
      type = "nixos";
    };
    started = true;
    unprivileged = true;
    inherit vm_id;
  };
in {
  terraform = {
    cloud = {
      organization = "euls-scepter";
      workspaces.name = "proxmoxnixlab-tfstate";
    };
    required_providers.proxmox = {
      source = "bpg/proxmox";
      version = "0.82.1";
    };
  };

  variable = {
    proxmox_username.type = "string";
    proxmox_password.type = "string";
  };

  provider.proxmox = {
    endpoint = "https://10.0.0.108:8006";
    insecure = true;
    username = lib.tfRef "var.proxmox_username";
    password = lib.tfRef "var.proxmox_password";
    ssh.agent = true;
  };

  resource.proxmox_virtual_environment_file.nixostar = {
    content_type = "vztmpl";
    datastore_id = "local";
    node_name = "pve";
    source_file.path = "./result/tar/tarball/nixos.tar.xz";
  };

  resource.proxmox_virtual_environment_container =
    builtins.mapAttrs
    (
      ct_name: ct_prop:
        mkCT {
          vm_name = ct_name;
          inherit
            (ct_prop)
            cpu_cores
            disk_size
            ipv4_full
            memory
            mount_point
            vm_id
            ;
        }
    )
    props.cts;
}
