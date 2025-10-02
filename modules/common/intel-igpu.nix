{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.intel-igpu;
in {
  options.intel-igpu = {
    enable = lib.mkEnableOption "Enable Intel iGPU";

    mediagpu_gid = lib.mkOption {
      default = 2999;
      description = "gid for mediagpu group(must match gid of mediagpu in pve)";
      type = lib.types.int;
    };

    user = lib.mkOption {
      default = null;
      description = "Username to add into mediagpu group for Intel iGPU access";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        pkgs.intel-gpu-tools
        pkgs.libva-utils
      ];
      variables.LIBVA_DRIVER_NAME = "iHD";
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vpl-gpu-rt
      ];
    };

    users = {
      groups.mediagpu.gid = cfg.mediagpu_gid;
      users = lib.mkIf (cfg.user != null) {
        "${cfg.user}".extraGroups = [
          "mediagpu"
          "video"
        ];
      };
    };
  };
}
