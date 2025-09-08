{modulesPath, ...}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  services = {
    cloud-init = {
      enable = true;
      network.enable = true;
    };

    qemuGuest.enable = true;
  };
}
