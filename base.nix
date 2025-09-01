{
  inputs,
  props,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  boot.kernelParams = ["ipv6.disable=1"];

  networking = {
    enableIPv6 = false;
    hostName = "";
    nameservers = ["10.0.0.150"];
    useDHCP = false;
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  security.sudo.wheelNeedsPassword = false;

  services = {
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
  };

  system.stateVersion = "25.11";

  users.users.ops = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = props.common_config.authorized_keys;
  };
}
