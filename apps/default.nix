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
    ["apply" "destroy" "plan"]
    |> map (action: {
      name = "proxmox-${action}";
      value = {
        type = "app";
        program = mkTerraformProgramForProxmox action;
      };
    })
    |> builtins.listToAttrs
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
                (
                  ((builtins.attrValues props.cts) ++ (builtins.attrValues props.vms))
                  |> builtins.filter (host_prop: host_prop.need_sops_pk)
                  |> map (host_prop: host_prop.ipv4_short)
                )
                |> builtins.concatStringsSep " "
              })

              IGPU_PATCH_NEEDED_HOSTS=(${
                (
                  (builtins.attrValues props.cts)
                  |> builtins.filter (ct_prop: ct_prop.need_igpu_patch)
                  |> map (ct_prop: ct_prop.ipv4_short)
                )
                |> builtins.concatStringsSep " "
              })

              TS_PATCH_NEEDED_HOSTS=(${
                (
                  (builtins.attrValues props.cts)
                  |> builtins.filter (ct_prop: ct_prop.need_ts_patch)
                  |> map (ct_prop: ct_prop.ipv4_short)
                )
                |> builtins.concatStringsSep " "
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
