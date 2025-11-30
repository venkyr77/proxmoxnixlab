let
  inherit (import ./helper.nix) mkqpfromcfs mkqpfromcf;
in [
  (mkqpfromcf "Bluray-2160p Remux")
  (mkqpfromcf "WEBDL-2160p")
  (mkqpfromcf "Bluray-1080p Remux")
  (mkqpfromcf "WEBDL-1080p")
  (mkqpfromcfs {
    name = "BLURAY";
    qualities = [
      "Bluray-2160p Remux"
      "Bluray-1080p Remux"
    ];
    unpgrade_until_quality = "Bluray-2160p Remux";
  })
  (mkqpfromcfs {
    name = "WEBDL";
    qualities = [
      "WEBDL-2160p"
      "WEBDL-1080p"
    ];
    unpgrade_until_quality = "WEBDL-2160p";
  })
  (mkqpfromcfs {
    name = "ALL";
    qualities = [
      "Bluray-2160p Remux"
      "WEBDL-2160p"
      "Bluray-1080p Remux"
      "WEBDL-1080p"
    ];
    unpgrade_until_quality = "Bluray-2160p Remux";
  })
]
