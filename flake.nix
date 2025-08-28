{
  description = "proxmox + nixos vms flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    mkNixFormatter = {pkgs}:
      pkgs.writeShellApplication {
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
  in {
    formatter = builtins.listToAttrs (
      map (sys: {
        name = sys;
        value = mkNixFormatter {pkgs = nixpkgs.legacyPackages.${sys};};
      })
      systems
    );
  };
}
