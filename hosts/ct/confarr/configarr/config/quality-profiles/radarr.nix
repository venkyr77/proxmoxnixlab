let
  inherit (import ./helper.nix) mkallcfqp mksinglecfqp;
in [
  (mksinglecfqp "Remux-2160p")
  (mksinglecfqp "Bluray-2160p")
  (mksinglecfqp "WEBDL-2160p")
  (mksinglecfqp "Remux-1080p")
  (mksinglecfqp "Bluray-1080p")
  (mksinglecfqp "WEBDL-1080p")
  (mkallcfqp {
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
