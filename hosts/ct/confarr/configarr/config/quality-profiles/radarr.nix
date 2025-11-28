let
  inherit (import ./helper.nix) mkqpfromcfs mkqpfromcf;
in [
  (mkqpfromcf "Remux-2160p")
  (mkqpfromcf "Bluray-2160p")
  (mkqpfromcf "WEBDL-2160p")
  (mkqpfromcf "Remux-1080p")
  (mkqpfromcf "Bluray-1080p")
  (mkqpfromcf "WEBDL-1080p")
  (mkqpfromcfs {
    name = "ALL";
    qualities = [
      "Remux-2160p"
      "Bluray-2160p"
      "WEBDL-2160p"
      "Remux-1080p"
      "Bluray-1080p"
      "WEBDL-1080p"
    ];
    unpgrade_until_quality = "Remux-2160p";
  })
]
