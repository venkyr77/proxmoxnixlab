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
      dns.servers = [props.cts.unbound.ipv4_short];
      hostname = vm_name;
      ip_config.ipv4 = {
        address = "${ipv4_full}";
        gateway = "10.0.0.1";
      };
    };
    memory.dedicated = memory;
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
    inherit vm_id;
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
        dns.servers = [props.cts.unbound.ipv4_short];
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
    nixostar = {
      content_type = "vztmpl";
      datastore_id = "local";
      node_name = "pve";
      source_file.path = "./result/tar/tarball/nixos.tar.xz";
    };
  };

  resource = {
    proxmox_virtual_environment_container =
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
              vm_id
              ;
          }
      )
      props.cts;
    proxmox_virtual_environment_vm =
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
  };
}
