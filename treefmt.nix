{pkgs, ...}: {
  projectRootFile = "flake.nix";

  programs = {
    deadnix = {
      enable = true;
      priority = 10;
    };

    statix = {
      enable = true;
      package = pkgs.statix.overrideAttrs (_old: rec {
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          allowBuiltinFetchGit = true;
          lockFile = "${src}/Cargo.lock";
        };
        src = pkgs.fetchFromGitHub {
          hash = "sha256-duH6Il124g+CdYX+HCqOGnpJxyxOCgWYcrcK0CBnA2M=";
          owner = "oppiliappan";
          repo = "statix";
          rev = "master";
        };
      });
      priority = 20;
    };

    alejandra = {
      enable = true;
      priority = 30;
    };

    shellcheck = {
      enable = true;
    };

    shfmt = {
      enable = true;
    };
  };
}
