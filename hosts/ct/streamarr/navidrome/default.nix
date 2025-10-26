{name, ...}: {
  services.navidrome = {
    enable = true;
    group = name;
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/mnt/music";
    };
    user = name;
  };
}
