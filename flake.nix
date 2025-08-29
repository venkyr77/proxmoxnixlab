{
  description = "proxmox + nixos vms flake";

  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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
    vm_props = import ./vm_props.nix;
  in {
    apps.${system} = let
      terranixProxmoxConf = terranix.lib.terranixConfiguration {
        extraArgs = {inherit vm_props;};
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
      builtins.mapAttrs (vm: conf: {
        hostname = "${vm_props.${vm}.ipv4_short}";
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

    nixosConfigurations = builtins.mapAttrs (vm: vm_prop:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            system
            ;
        };
        modules = [
          nixos-generators.nixosModules.raw-efi
          ./modules/proxmox-vm-base.nix
          ./vm/${vm}
        ];
      })
    vm_props;

    packages.${system}.default = nixos-generators.nixosGenerate {
      format = "raw-efi";
      modules = [./modules/proxmox-vm-base.nix];
      specialArgs = {inherit inputs;};
      inherit system;
    };
  };
}
