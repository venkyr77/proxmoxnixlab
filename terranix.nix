{lib, ...}: {
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
}
