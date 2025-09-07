{
  boot.kernelParams = ["ipv6.disable=1"];

  networking = {
    enableIPv6 = false;
    hostName = "";
    useDHCP = false;
  };

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    require-sigs = false;
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
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
  };

  system.stateVersion = "25.11";

  users.users.ops = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKq26n2TKyJF/LSKXTjRHlCS1rG4+P/cQkG8dBufDkh venkyrocker7777@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlTUXrGWkLvAxORPsjc4mCkBNr1jtKJoJh6fNoj8zYj venkyrocker7777@gmail.com"
    ];
  };
}
