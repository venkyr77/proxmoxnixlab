{lib, ...}: let
  vm_props = {
    miracle = {
      cpu_cores = 16;
      cpu_host_type = "host";
      disk_size = 256;
      hostpci = {
        device = "hostpci0";
        id = "0000:01:00.0";
        rombar = true;
        xvga = true;
      };
      ipv4_full = "10.0.0.100/24";
      ipv4_short = "10.0.0.100";
      memory = 64 * 1024;
      vm_id = 100;
    };
  };
  mkVM = {
    cpu_cores,
    cpu_host_type,
    disk_size,
    hostpci,
    ipv4_full,
    memory,
    vm_id,
    vm_name,
  }:
    {
      agent.enabled = true;
      cpu = {
        cores = cpu_cores;
        type = cpu_host_type;
      };
      depends_on = ["proxmox_virtual_environment_file.nixosbase"];
      disk = {
        interface = "scsi0";
        file_id = "local:iso/nixos.img";
        file_format = "raw";
        size = disk_size;
      };
      initialization = {
        ip_config.ipv4 = {
          address = "${ipv4_full}";
          gateway = "10.0.0.1";
        };
        user_account = {
          username = "ops";
          keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKq26n2TKyJF/LSKXTjRHlCS1rG4+P/cQkG8dBufDkh venkyrocker7777@gmail.com"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlTUXrGWkLvAxORPsjc4mCkBNr1jtKJoJh6fNoj8zYj venkyrocker7777@gmail.com"
          ];
        };
      };
      memory.dedicated = memory;
      name = "${vm_name}";
      network_device = {};
      node_name = "pve";
      started = true;
      stop_on_destroy = true;
      inherit vm_id;
    }
    // (
      if hostpci != null
      then {inherit hostpci;}
      else {}
    );
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

  resource.proxmox_virtual_environment_file.nixosbase = {
    content_type = "iso";
    datastore_id = "local";
    node_name = "pve";
    source_file.path = "./result/nixos.img";
  };

  resource.proxmox_virtual_environment_vm =
    builtins.mapAttrs
    (
      vm_name: vm_prop:
        mkVM {
          inherit vm_name;
          inherit
            (vm_prop)
            cpu_cores
            cpu_host_type
            disk_size
            hostpci
            ipv4_full
            memory
            vm_id
            ;
        }
    )
    vm_props;
}
