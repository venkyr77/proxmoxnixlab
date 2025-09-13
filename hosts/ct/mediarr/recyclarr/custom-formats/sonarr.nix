let
  hdr_formats = [
    "505d871304820ba7106b693be6fe4a9e" # HDR
    "7c3a61a9c6cb04f52f1544be6d44a026" # DV Boost
    "0c4b99df9206d2cfac3c05ab897dd62a" # HDR10+ Boost
    "9b27ab6498ec0f31a3353992e19434ca" # DV (WEBDL)
  ];
  unwanted = [
    "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
    "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
    "e2315f990da2e2cbfc9fa5b7a6fcfe48" # LQ (Release Title)
    "47435ece6b99a0b477caf360e79ba0bb" # x265 (HD)
    "fbcb31d8dabd2a319072b84fc0b7249c" # Extras
    "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
  ];
  misc_required = [
    "ec8fa7296b64e8cd390a1600981f3923" # Repack/Proper
    "eb3d5cc0a2be0db205fb823640db6a3c" # Repack v2
    "44e7c4de10ae50265753082e5dc76047" # Repack v3
  ];
  general_streaming_services = [
    "d660701077794679fd59e8bdf4ce3a29" # AMZN
    "f67c9ca88f463a48346062e8ad07713f" # ATVP
    "77a7b25585c18af08f60b1547bb9b4fb" # CC
    "36b72f59f4ea20aad9316f475f2d9fbb" # DCU
    "89358767a60cc28783cdc3d0be9388a4" # DSNP
    "a880d6abc21e7c16884f3ae393f84179" # HMAX
    "7a235133c87f7da4c8cccceca7e3c7a6" # HBO
    "f6cce30f1733d5c8194222a7507909bb" # HULU
    "0ac24a2a68a9700bcb7eeca8e5cd644c" # iT
    "81d1fbf600e2540cee87f3a23f9d3c1c" # MAX
    "d34870697c9db575f17700212167be23" # NF
    "c67a75ae4a1715f2bb4d492755ba4195" # PMTP
    "1656adc6d7bb2c8cca6acfb6592db421" # PCOK
    "ae58039e1319178e6be73caab5c42166" # SHO
    "1efe8da11bfd74fbbcd4d8117ddb9213" # STAN
    "9623c5c9cac8e939c1b9aedd32f640bf" # SYFY
  ];
  general_streaming_services_uhd = [
    "43b3cf48cb385cd3eac608ee6bca7f09" # UHD Streaming Boost
    "d2d299244a92b8a52d4921ce3897a256" # UHD Streaming Cut
  ];
  remux_tiers = [
    "9965a052eb87b0d10313b1cea89eb451" # Remux Tier 01
    "8a1d0c3d7497e741736761a1da866a2e" # Remux Tier 02
  ];
  web_tiers = [
    "e6258996055b9fbab7e9cb2f75819294" # WEB Tier 01
    "58790d4e2fdcd9733aa7ae68ba2bb503" # WEB Tier 02
    "d84935abd3f8556dcd51d4f27e22d0a6" # WEB Tier 03
    "d0c516558625b04b363fa6c5c2c7cfd4" # WEB Scene
  ];
  audio_optional = [
    "0d7824bb924701997f874e7ff7d4844a" # TrueHD ATMOS
    "9d00418ba386a083fbf4d58235fc37ef" # DTS X
    "b6fbafa7942952a13e17e2b1152b539a" # ATMOS (undefined)
    "4232a509ce60c4e208d13825b7c06264" # DD+ ATMOS
    "1808e4b9cee74e064dfae3f1db99dbfe" # TrueHD
    "c429417a57ea8c41d57e6990a8b0033f" # DTS-HD MA
    "851bd64e04c9374c51102be3dd9ae4cc" # FLAC
    "30f70576671ca933adbdcfc736a69718" # PCM
    "cfa5fbd8f02a86fc55d8d223d06a5e1f" # DTS-HD HRA
    "63487786a8b01b7f20dd2bc90dd4a477" # DD+
    "c1a25cd67b5d2e08287c957b1eb903ec" # DTS-ES
    "5964f2a8b3be407d083498e4459d05d0" # DTS
    "a50b8a0c62274a7c38b09a9619ba9d86" # AAC
    "dbe00161b08a25ac6154c55f95e6318d" # DD
  ];
  misc_optional = [
    "32b367365729d530ca1c124a0b180c64" # Bad Dual Groups
    "82d40da2bc6923f41e14394075dd4b03" # No-RlsGroup
    "06d66ab109d4d2eddb2794d21526d140" # Retags
    "1b3994c551cbb92a2c781af061f4ab44" # Scene
  ];
  misc_uhd_optional = [
    "2016d1676f5ee13a5b7257ff86ac9a93" # SDR
    "83304f261cf516bb208c18c54c0adf97" # SDR (no WEBDL)
    "9b64dff695c2115facf1b6ea59c9bd07" # x265 (no HDR/DV)
  ];
in [
  {
    assign_scores_to = [
      {
        name = "Remux + WEB 2160p";
      }
    ];
    trash_ids = let
      hq_source_groups = remux_tiers ++ web_tiers;
    in
      hdr_formats
      ++ unwanted
      ++ misc_required
      ++ general_streaming_services
      ++ general_streaming_services_uhd
      ++ hq_source_groups
      ++ audio_optional
      ++ misc_optional
      ++ misc_uhd_optional;
  }
  {
    assign_scores_to = [
      {
        name = "WEB-2160p";
      }
    ];
    trash_ids = let
      hq_source_groups = web_tiers;
    in
      hdr_formats
      ++ unwanted
      ++ misc_required
      ++ general_streaming_services
      ++ general_streaming_services_uhd
      ++ hq_source_groups
      ++ misc_optional
      ++ misc_uhd_optional;
  }
  {
    assign_scores_to = [
      {
        name = "Remux + WEB 1080p";
      }
    ];
    trash_ids = let
      hq_source_groups = remux_tiers ++ web_tiers;
    in
      unwanted
      ++ misc_required
      ++ general_streaming_services
      ++ hq_source_groups
      ++ audio_optional
      ++ misc_optional;
  }
  {
    assign_scores_to = [
      {
        name = "WEB-1080p";
      }
    ];
    trash_ids = let
      hq_source_groups = web_tiers;
    in
      unwanted
      ++ misc_required
      ++ general_streaming_services
      ++ hq_source_groups
      ++ misc_optional;
  }
]
