{
  inputs,
  nasIP,
  pkgs,
  props,
  pveIP,
  system,
}: let
  terranixProxmoxConf = inputs.terranix.lib.terranixConfiguration {
    extraArgs = {inherit props;};
    modules = [../terranix];
    inherit system;
  };

  mkTerraformProgramForProxmox = action:
    toString (
      pkgs.writers.writeBash
      action
      ''
        if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
        cp ${terranixProxmoxConf} config.tf.json \
          && ${pkgs.terraform}/bin/terraform login \
          && ${pkgs.terraform}/bin/terraform init \
          && ${pkgs.terraform}/bin/terraform ${action} -var-file=./vals.tfvars -parallelism=1
      ''
    );
in
  (
    builtins.listToAttrs (map (action: {
      name = "proxmox-${action}";
      value = {
        type = "app";
        program = mkTerraformProgramForProxmox action;
      };
    }) ["apply" "destroy" "plan"])
  )
  // (
    builtins.listToAttrs (map (app: {
        name = app;
        value = {
          type = "app";
          program = toString (
            pkgs.writeScript
            app
            # sh
            ''
              #!/usr/bin/env bash

              NAS_IP=${nasIP}
              PVE_IP=${pveIP}

              ${(builtins.readFile ./scripts/${app}.sh)}
            ''
          );
        };
      })
      [
        "copy-sops-pk"
        "create-cifs-automount"
        "igpu-host-bootstrap"
        "igpu-lxc-patch"
        "pve-authorize-ssh-pk"
        "tailscale-lxc-patch"
        "zfs-create-dataset"
        "zfs-grant-user-acl"
      ])
  )
