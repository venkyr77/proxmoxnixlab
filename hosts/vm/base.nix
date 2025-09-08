{
  name,
  props,
  ...
}: {
  imports = [
    ../../minimal.nix
    ../../minimal-vm.nix
    ../base.nix
  ];

  deployment = {
    targetHost = props.vms.${name}.ipv4_short;
    targetUser = "ops";
  };
}
