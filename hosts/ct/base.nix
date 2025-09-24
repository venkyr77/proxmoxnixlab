{
  name,
  props,
  ...
}: {
  imports = [
    ../../minimal.nix
    ../base.nix
  ];

  deployment = {
    targetHost = props.cts.${name}.ipv4_short;
    targetUser = "ops";
  };
}
