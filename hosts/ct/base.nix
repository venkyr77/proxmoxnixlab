{
  name,
  props,
  ...
}: {
  imports = [
    ../base.nix

    ({modulesPath, ...}: {
      imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"];
    })
  ];

  deployment = {
    targetHost = props.cts.${name}.ipv4_short;
    targetUser = "ops";
  };
}
