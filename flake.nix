{
  description = "nixos proxmox fleet managed by colmena";

  inputs = {
    authentik-nix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:nix-community/authentik-nix";
    };
    colmena = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:zhaofengli/colmena";
    };
    declarative-jellyfin = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:venkyr77/declarative-jellyfin?ref=test";
    };
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
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
    systems.url = "github:nix-systems/default";
    terranix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:terranix/terranix";
    };
  };

  outputs = {
    authentik-nix,
    colmena,
    declarative-jellyfin,
    nixos-generators,
    nixpkgs,
    sops-nix,
    terranix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    props = import ./props.nix;

    nasIP = "10.0.0.222";
    pveIP = "10.0.0.108";
  in {
    apps.${system} =
      (
        let
          terranixProxmoxConf = terranix.lib.terranixConfiguration {
            extraArgs = {inherit props;};
            modules = [./terranix];
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
          builtins.listToAttrs (map (action: {
            name = "proxmox-${action}";
            value = {
              type = "app";
              program = mkTerraformProgramForProxmox action;
            };
          }) ["apply" "destroy" "plan"])
      )
      // (builtins.listToAttrs (map (app: {
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
        ]));

    colmenaHive = colmena.lib.makeHive ({
        meta = {
          nixpkgs = pkgs;
          specialArgs = {
            inherit props;
          };
        };
      }
      // (builtins.mapAttrs (ct: _ct_prop: {
          imports =
            [
              nixos-generators.nixosModules.proxmox-lxc
              sops-nix.nixosModules.sops
              ./hosts/ct/base.nix
              ./hosts/ct/${ct}
            ]
            ++ (
              if ct == "authentik"
              then [authentik-nix.nixosModules.default]
              else []
            )
            ++ (
              if ct == "jellyfin"
              then [declarative-jellyfin.nixosModules.default]
              else []
            );
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

    packages.${system}.mktar = nixos-generators.nixosGenerate {
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
}
