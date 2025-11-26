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
  // {
    authentik = {
      host = props.cts.auth-n-pass.ipv4_full;
      user = "authentik";
    };
    gatus = {
      host = props.cts.angel.ipv4_full;
      user = "gatus";
    };
    grafana = {
      host = props.cts.angel.ipv4_full;
      user = "grafana";
    };
    linkwarden = {
      host = props.cts.tools.ipv4_full;
      user = "linkwarden";
    };
    memos = {
      host = props.cts.tools.ipv4_full;
      user = "memos";
    };
    vaultwarden = {
      host = props.cts.auth-n-pass.ipv4_full;
      user = "vaultwarden";
    };
  }
