{modulesPath, ...}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  networking = {
    hostName = "";
    useDHCP = false;
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    cloud-init = {
      enable = true;
      network.enable = true;
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    qemuGuest.enable = true;
  };

  system.stateVersion = "25.11";

  users = {
    users.ops = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };
}
