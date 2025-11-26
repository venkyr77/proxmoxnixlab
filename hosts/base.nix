{
  name,
  lib,
  props,
  ...
}: {
  imports = [
    ../minimal.nix
  ];

  networking.nameservers = lib.mkIf (name != "dns") [
    props.cts.dns.ipv4_short
  ];

  sops = {
    age.keyFile = "/etc/sopspk-secret/sopspk";
    defaultSopsFormat = "binary";
  };
}
