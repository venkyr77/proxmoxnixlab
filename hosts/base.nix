{
  lib,
  name,
  props,
  ...
}: {
  networking.nameservers = lib.mkIf (!(name == "unbound" || name == "adg-tailscale")) [
    props.cts.adg-tailscale.ipv4_short
  ];

  sops = {
    age.keyFile = "/etc/${name}/sopspk";
    defaultSopsFormat = "binary";
  };
}
