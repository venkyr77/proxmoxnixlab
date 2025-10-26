{
  name,
  lib,
  props,
  ...
}: {
  imports = [
    ../../minimal.nix
  ];

  networking.nameservers = lib.mkIf (name != "dns") [
    props.cts.dns.ipv4_short
  ];

  deployment = {
    targetHost = props.cts.${name}.ipv4_short;
    targetUser = "ops";
  };

  sops = {
    age.keyFile = "/etc/sopspk-secret/sopspk";
    defaultSopsFormat = "binary";
  };
}
