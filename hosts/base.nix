{
  lib,
  name,
  props,
  ...
}: {
  imports = [
    ../minimal.nix
  ];

  networking.nameservers = lib.mkIf (!(name == "unbound" || name == "adg")) [
    props.cts.adg.ipv4_short
  ];

  sops = {
    age.keyFile = "/etc/${name}/sopspk";
    defaultSopsFormat = "binary";
  };
}
