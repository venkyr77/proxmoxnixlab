{
  inputs,
  modulesPath,
  props,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    inputs.sops-nix.nixosModules.sops
  ];

  boot.kernelParams = ["ipv6.disable=1"];

  networking = {
    enableIPv6 = false;
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
      inherit (props.common_config.services.prometheus.exporters.node) port;
    };

    qemuGuest.enable = true;
  };

  system.stateVersion = "25.11";

  users.users.ops = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = props.common_config.authorized_keys;
  };
}
