{inputs, ...}: {
  imports = [
    inputs.authentik-nix.nixosModules.default
    ./authentik
    ./vaultwarden
  ];
}
