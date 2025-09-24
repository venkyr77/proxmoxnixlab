[
  {
    name = "Remux + WEB 2160p";
    qualities = [
      {
        name = "Bluray-2160p Remux";
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
      until_quality = "Bluray-2160p Remux";
      until_score = 10000;
    };
  }
  {
    name = "WEB-2160p";
    qualities = [
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
      until_quality = "WEB 2160p";
      until_score = 10000;
    };
  }
  {
    name = "Remux + WEB 1080p";
    qualities = [
      {
        name = "Bluray-1080p Remux";
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
      until_quality = "Bluray-1080p Remux";
      until_score = 10000;
    };
  }
  {
    name = "WEB-1080p";
    qualities = [
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
      until_quality = "WEB 1080p";
      until_score = 10000;
    };
  }
]
