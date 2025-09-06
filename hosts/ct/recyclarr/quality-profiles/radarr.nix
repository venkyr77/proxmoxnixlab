[
  {
    name = "Remux + WEB 2160p";
    qualities = [
      {
        name = "Remux-2160p";
      }
      {
        name = "WEB 2160p";
        qualities = [
          "WEBDL-2160p"
          "WEBRip-2160p"
        ];
      }
    ];
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = "Remux-2160p";
      until_score = 10000;
    };
  }
  {
    name = "Remux + WEB 1080p";
    qualities = [
      {
        name = "Remux-1080p";
      }
      {
        name = "WEB 1080p";
        qualities = [
          "WEBDL-1080p"
          "WEBRip-1080p"
        ];
      }
    ];
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = "Remux-1080p";
      until_score = 10000;
    };
  }
  {
    name = "UHD Bluray + WEB";
    qualities = [
      {
        name = "Bluray-2160p";
      }
      {
        name = "WEB 2160p";
        qualities = [
          "WEBDL-2160p"
          "WEBRip-2160p"
        ];
      }
    ];
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = "Bluray-2160p";
      until_score = 10000;
    };
  }
  {
    name = "HD Bluray + WEB";
    qualities = [
      {
        name = "Bluray-1080p";
      }
      {
        name = "WEB 1080p";
        qualities = [
          "WEBDL-1080p"
          "WEBRip-1080p"
        ];
      }
      {
        name = "Bluray-720p";
      }
    ];
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = "Bluray-1080p";
      until_score = 10000;
    };
  }
]
