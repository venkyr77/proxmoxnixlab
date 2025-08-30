{
  description = "proxmox + nixos vms flake";

  inputs = {
    deploy-rs = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:serokell/deploy-rs";
    };
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    terranix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:terranix/terranix";
    };
  };

  outputs = {
    deploy-rs,
    nixos-generators,
    nixpkgs,
    self,
    terranix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    props = import ./props.nix;
  in {
    apps.${system} = let
      terranixProxmoxConf = terranix.lib.terranixConfiguration {
        extraArgs = {inherit props;};
        modules = [./terranix.nix];
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

    deploy.nodes =
      builtins.mapAttrs (vm: _conf: {
        hostname = "${props.vms.${vm}.ipv4_short}";
        profiles.system = {
          path =
            deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.${vm};
          remoteBuild = true;
          sshUser = "ops";
          user = "root";
        };
      })
      self.nixosConfigurations;

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

    nixosConfigurations = builtins.mapAttrs (vm: _vm_prop:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            props
            system
            ;
        };
        modules = [
          nixos-generators.nixosModules.raw-efi
          ./proxmox-vm-base.nix
          ./vm/${vm}
        ];
      })
    props.vms;

    packages.${system}.default = nixos-generators.nixosGenerate {
      format = "raw-efi";
      modules = [./proxmox-vm-base.nix];
      specialArgs = {inherit inputs props;};
      inherit system;
    };
  };
}
