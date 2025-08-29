{modulesPath, ...}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  networking = {
    hostName = "";
    useDHCP = false;
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

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

    prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];
      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
        "--collector.wifi"
      ];
      openFirewall = true;
      port = 9100;
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
