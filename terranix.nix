{
  lib,
  props,
  ...
}: let
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
      bios = "ovmf";
      cpu = {
        cores = cpu_cores;
        type = cpu_host_type;
      };
      depends_on = ["proxmox_virtual_environment_file.nixosimg"];
      disk = {
        interface = "scsi0";
        file_id = "local:iso/nixos.img";
        file_format = "raw";
        size = disk_size;
      };
      efi_disk = {};
      initialization = {
        ip_config.ipv4 = {
          address = "${ipv4_full}";
          gateway = "10.0.0.1";
        };
        user_account.username = "ops";
      };
      machine = "q35";
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

  resource.proxmox_virtual_environment_file = {
    nixosimg = {
      content_type = "iso";
      datastore_id = "local";
      node_name = "pve";
      source_file.path = "./result/img/nixos.img";
    };
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
    props.vms;
}
