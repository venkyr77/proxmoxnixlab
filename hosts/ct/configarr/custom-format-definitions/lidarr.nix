[
  {
    trash_id = "lidarr-preferred-groups";
    trash_scores.default = 10;
    trash_description = "[lidarr] - Preferred Groups";
    name = "Preferred Groups";
    includeCustomFormatWhenRenaming = false;
    specifications = [
      {
        name = "DeVOiD";
        implementation = "ReleaseGroupSpecification";
        negate = false;
        required = false;
        fields.value = "\\bDeVOiD\\b";
      }
      {
        name = "PERFECT";
        implementation = "ReleaseGroupSpecification";
        negate = false;
        required = false;
        fields.value = "\\bPERFECT\\b";
      }
      {
        name = "ENRiCH";
        implementation = "ReleaseGroupSpecification";
        negate = false;
        required = false;
        fields.value = "\\bENRiCH\\b";
      }
    ];
  }
  {
    trash_id = "lidarr-cd";
    trash_scores.default = 2;
    trash_description = "[lidarr] - CD";
    name = "CD";
    includeCustomFormatWhenRenaming = false;
    specifications = [
      {
        name = "CD";
        implementation = "ReleaseTitleSpecification";
        negate = false;
        required = false;
        fields.value = "\\bCD\\b";
      }
    ];
  }
  {
    trash_id = "lidarr-web";
    trash_scores.default = 1;
    trash_description = "[lidarr] - WEB";
    name = "WEB";
    includeCustomFormatWhenRenaming = false;
    specifications = [
      {
        name = "WEB";
        implementation = "ReleaseTitleSpecification";
        negate = false;
        required = false;
        fields.value = "\\bWEB\\b";
      }
    ];
  }
  {
    trash_id = "lidarr-lossless";
    trash_scores.default = 1;
    trash_description = "[lidarr] - Lossless";
    name = "Lossless";
    includeCustomFormatWhenRenaming = false;
    specifications = [
      {
        name = "Flac";
        implementation = "ReleaseTitleSpecification";
        negate = false;
        required = false;
        fields.value = "\\blossless\\b";
      }
    ];
  }
  {
    trash_id = "lidarr-vinyl";
    trash_scores.default = -5;
    trash_description = "[lidarr] - Vinyl";
    name = "Vinyl";
    includeCustomFormatWhenRenaming = false;
    specifications = [
      {
        name = "Vinyl";
        implementation = "ReleaseTitleSpecification";
        negate = false;
        required = false;
        fields.value = "\\bVinyl\\b";
      }
    ];
  }
]
