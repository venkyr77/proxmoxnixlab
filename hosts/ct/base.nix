{
  name,
  lib,
  props,
  ...
}: {
  imports = [
    ../../minimal.nix
  ];

  networking.nameservers = lib.mkIf (name != "networking") [
    props.cts.networking.ipv4_short
  ];

  deployment = {
    targetHost = props.cts.${name}.ipv4_short;
    targetUser = "ops";
  };

  sops = {
    age.keyFile = "/etc/${name}/sopspk";
    defaultSopsFormat = "binary";
  };
}
