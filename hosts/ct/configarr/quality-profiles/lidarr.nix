[
  {
    name = "HQ";
    qualities = [
      {
        name = "FLAC 24bit";
      }
      {
        name = "FLAC";
      }
      {
        name = "WAV";
      }
      {
        name = "MP3-320";
      }
    ];
    quality_sort = "top";
    min_format_score = 1;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = "FLAC 24bit";
      until_score = 100;
    };
  }
]
