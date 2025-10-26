{
  lib,
  pkgs,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    pnpm test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share bundle.cjs
    makeWrapper ${lib.getExe pkgs.nodejs_24} $out/bin/configarr \
      --add-flags "$out/share/bundle.cjs"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/raydak-labs/configarr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Sync TRaSH Guides + custom configs with Sonarr/Radarr";
    homepage = "https://github.com/raydak-labs/configarr";
    license = lib.licenses.agpl3Only;
    mainProgram = "configarr";
    maintainers = with lib.maintainers; [lord-valen];
    platforms = lib.platforms.all;
  };

  nativeBuildInputs = [
    pkgs.makeBinaryWrapper
    pkgs.nodejs_24
    pkgs.pnpm.configHook
  ];

  pname = "configarr";

  pnpmDeps = pkgs.pnpm.fetchDeps {
    fetcherVersion = 1;
    hash = "sha256-tmEr5rX14DWeWo4FDArNU3yrFGRft3nuQ8TqXj6QNS4=";
    inherit (finalAttrs) pname src version;
  };

  src = pkgs.fetchFromGitHub {
    hash = "sha256-enPsUrHmcm2D+WCd3U5tBtB0i7orqhCPxukFgOLrHys=";
    owner = "venkyr77";
    repo = "configarr";
    rev = "nix";
  };

  version = "1.17.1";
})
