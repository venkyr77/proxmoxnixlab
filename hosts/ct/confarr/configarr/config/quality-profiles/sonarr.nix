let
  inherit (import ./helper.nix) mkallcfqp mksinglecfqp;
in [
  (mksinglecfqp "Bluray-2160p Remux")
  (mksinglecfqp "WEBDL-2160p")
  (mksinglecfqp "Bluray-1080p Remux")
  (mksinglecfqp "WEBDL-1080p")
  (mkallcfqp {
    qualities = [
      "Bluray-2160p Remux"
      "WEBDL-2160p"
      "Bluray-1080p Remux"
      "WEBDL-1080p"
    ];
    unpgrade_until_quality = "Bluray-2160p Remux";
  })
]
