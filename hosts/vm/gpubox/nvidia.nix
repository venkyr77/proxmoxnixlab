{config, ...}: {
  hardware = {
    graphics.enable = true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = ["nvidia"];
}
