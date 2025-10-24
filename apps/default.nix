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

              SOPS_PK_NEEDED_HOSTS=(${
                builtins.concatStringsSep " "
                (
                  map (ct: props.cts.${ct}.ipv4_short)
                  (builtins.attrNames (pkgs.lib.attrsets.filterAttrs (_: ct_prop: ct_prop.need_sops_pk) props.cts))
                )
              })

              IGPU_PATCH_NEEDED_HOSTS=(${
                builtins.concatStringsSep " "
                (
                  map (ct: toString props.cts.${ct}.vm_id)
                  (builtins.attrNames (pkgs.lib.attrsets.filterAttrs (_: ct_prop: ct_prop.need_igpu_patch) props.cts))
                )
              })

              TS_PATCH_NEEDED_HOSTS=(${
                builtins.concatStringsSep " "
                (
                  map (ct: toString props.cts.${ct}.vm_id)
                  (builtins.attrNames (pkgs.lib.attrsets.filterAttrs (_: ct_prop: ct_prop.need_ts_patch) props.cts))
                )
              })

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
        "zfs-create-pool"
        "zfs-grant-user-acl"
      ])
  )
