{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.intel-igpu;
in {
  options.intel-igpu = {
    user = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Username to add into mediagpu group for Intel iGPU access.";
    };
  };

  config = {
    environment.systemPackages = [
      pkgs.intel-gpu-tools
      pkgs.libva-utils
    ];

    users.groups.mediagpu.gid = 2999;

    users.users = lib.mkIf (cfg.user != null) {
      "${cfg.user}".extraGroups = ["mediagpu" "video"];
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vpl-gpu-rt
      ];
    };

    environment.variables.LIBVA_DRIVER_NAME = "iHD";
  };
}
