{pkgs}:
pkgs.stdenv.mkDerivation {
  buildInputs = [pkgs.stdenv.cc.cc.lib];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp memos $out/bin/memos
    runHook postInstall
  '';

  nativeBuildInputs = [pkgs.autoPatchelfHook];

  pname = "memos";

  src = pkgs.fetchurl {
    sha256 = "sha256-hRV7oHHbPVo2Nw5kUklisuQdCPYfy7GB5XMZJH/yAbU=";
    url = "https://github.com/usememos/memos/releases/download/v0.25.3/memos_v0.25.3_linux_amd64.tar.gz";
  };

  unpackPhase = ''
    tar -xzf $src
  '';

  version = "v0.25.3";
}
