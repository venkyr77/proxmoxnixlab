{
  description = "proxmox + nixos vms flake";

  inputs = {
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixos-generators,
    nixpkgs,
    terranix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    mkTerraformConfiguration = terranix.lib.terranixConfiguration {
      extraArgs = {inherit inputs;};
      modules = [./terranix.nix];
      inherit system;
    };

    mkTerraformProgram = action:
      toString (pkgs.writers.writeBash action ''
        if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
        cp ${mkTerraformConfiguration} config.tf.json \
          && ${pkgs.terraform}/bin/terraform init \
          && ${pkgs.terraform}/bin/terraform ${action}
      '');
  in {
    apps.${system} = builtins.listToAttrs (map (action: {
      name = action;
      value = {
        type = "app";
        program = mkTerraformProgram action;
      };
    }) ["apply" "destroy" "plan"]);

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

    packages.${system}.default = nixos-generators.nixosGenerate {
      format = "raw";
      modules = [./modules/proxmox-vm-base.nix];
      specialArgs = {inherit inputs;};
      inherit system;
    };
  };
}
