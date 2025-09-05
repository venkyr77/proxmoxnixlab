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
    terranix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:terranix/terranix";
    };
  };

  outputs = {
    colmena,
    nixos-generators,
    nixpkgs,
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
      }) ["apply" "destroy" "plan"]);

    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = pkgs;
        specialArgs = {
          inherit props;
        };
      };

      unbound = {
        imports = [
          ./hosts/ct/base.nix
        ];
      };
    };

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
          ./hosts/base.nix
          {
            image.baseName = "nixos";
          }
        ];
        inherit system;
      };
    };
  };
}
