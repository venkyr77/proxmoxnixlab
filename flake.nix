{
  description = "proxmox + nixos vms flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {system, ...}: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.writeShellApplication {
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
      };
    };
}
