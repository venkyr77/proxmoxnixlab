{
  name,
  lib,
  props,
  ...
}: {
  imports = [
    ../../minimal.nix
  ];

  networking.nameservers = lib.mkIf (!(name == "unbound" || name == "adg-tailscale")) [
    props.cts.unbound.ipv4_short
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
