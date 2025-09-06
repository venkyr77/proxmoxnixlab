{
  description = "nixos proxmox fleet managed by colmena";

  inputs = {
    colmena = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:zhaofengli/colmena";
    };
    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terranix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:terranix/terranix";
    };
  };

  outputs = {
    colmena,
    nixos-generators,
    nixpkgs,
    sops-nix,
    terranix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    props = import ./props.nix;
  in {
    apps.${system} = let
      terranixProxmoxConf = terranix.lib.terranixConfiguration {
        extraArgs = {inherit props;};
        modules = [./terranix];
        inherit system;
      };

      mkTerraformProgramForProxmox = action:
        toString (pkgs.writers.writeBash action ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${terranixProxmoxConf} config.tf.json \
            && ${pkgs.terraform}/bin/terraform login \
            && ${pkgs.terraform}/bin/terraform init \
            && ${pkgs.terraform}/bin/terraform ${action} -var-file=./vals.tfvars -parallelism=1
        '');
    in
      builtins.listToAttrs (map (action: {
        name = "proxmox-${action}";
        value = {
          type = "app";
          program = mkTerraformProgramForProxmox action;
        };
      }) ["apply" "destroy" "plan"])
      // {
        copy-sops-pk = {
          type = "app";
          program = toString (pkgs.writers.writeBash "copy-sops-pk" ''
            set -euo pipefail
            read -r -p "Enter host ip: " host
            ssh -t "ops@$host" 'sudo mkdir -p "/etc/$HOSTNAME"'
            scp "$HOME/.config/sops/age/keys.txt" "ops@$host:~/sopspk"
            ssh -t "ops@$host" 'sudo mv "$HOME/sopspk" "/etc/$HOSTNAME"'
          '');
        };
      };

    colmenaHive = colmena.lib.makeHive ({
        meta = {
          nixpkgs = pkgs;
          specialArgs = {
            inherit props;
          };
        };
      }
      // (builtins.mapAttrs (ct: _ct_prop: {
          imports = [
            sops-nix.nixosModules.sops
            ./hosts/ct/base.nix
            ./hosts/ct/${ct}
          ];
        })
        props.cts));

    formatter.${system} = pkgs.writeShellApplication {
      name = "format";
      runtimeInputs = builtins.attrValues {
        inherit (pkgs) alejandra deadnix fd statix;
      };
      text = ''
        fd "$@" -t f -e nix -x statix fix -- '{}'
        fd "$@" -t f -e nix -X deadnix -e -- '{}'
        fd "$@" -t f -e nix -X alejandra '{}'
      '';
    };

    packages.${system} = {
      mktar = nixos-generators.nixosGenerate {
        format = "proxmox-lxc";
        modules = [
          ./minimal.nix
          {
            image.baseName = "nixos";
          }
        ];
        inherit system;
      };
    };
  };
}
