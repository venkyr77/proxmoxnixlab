[
  {
    name = "Remux + WEBDL 2160p";
    qualities = [
      {
        name = "Remux-2160p";
      }
      {
        name = "WEBDL-2160p";
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
    name = "Remux + WEBDL 1080p";
    qualities = [
      {
        name = "Remux-1080p";
      }
      {
        name = "WEBDL-1080p";
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
    name = "Bluray + WEBDL 2160p";
    qualities = [
      {
        name = "Bluray-2160p";
      }
      {
        name = "WEBDL-2160p";
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
    name = "Bluray + WEBDL 1080p";
    qualities = [
      {
        name = "Bluray-1080p";
      }
      {
        name = "WEBDL-1080p";
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
