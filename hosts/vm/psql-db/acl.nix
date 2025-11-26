{props}: let
  mkACLEntriesForARRName = name: {
    "${name}" = {
      host = props.cts.fetcharr.ipv4_full;
      user = "fetcharr";
    };
    "${name}-logs" = {
      host = props.cts.fetcharr.ipv4_full;
      user = "fetcharr";
    };
    "${name}-main" = {
      host = props.cts.fetcharr.ipv4_full;
      user = "fetcharr";
    };
  };
in
  mkACLEntriesForARRName "lidarr"
  // mkACLEntriesForARRName "prowlarr"
  // mkACLEntriesForARRName "radarr"
  // mkACLEntriesForARRName "sonarr"
