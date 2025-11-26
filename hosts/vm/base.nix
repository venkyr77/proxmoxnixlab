{
  name,
  props,
  ...
}: {
  imports = [
    ../../minimal-vm.nix
    ../base.nix
  ];

  deployment = {
    targetHost = props.vms.${name}.ipv4_short;
    targetUser = "ops";
  };
}
