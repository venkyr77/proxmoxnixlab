{
  mkqpfromcfs = {
    name,
    qualities,
    unpgrade_until_quality,
  }: {
    inherit name;
    qualities = qualities |> map (quality: {name = quality;});
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = unpgrade_until_quality;
      until_score = 10000;
    };
  };
  mkqpfromcf = quality: {
    name = quality;
    qualities = [
      {
        name = quality;
      }
    ];
    quality_sort = "top";
    min_format_score = 0;
    reset_unmatched_scores.enabled = true;
    upgrade = {
      allowed = true;
      until_quality = quality;
      until_score = 10000;
    };
  };
}
