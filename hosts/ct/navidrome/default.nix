{
  imports = [
    ../../../modules/users/mediarr.nix
  ];

  mediarr.make_user = true;

  services.navidrome = {
    enable = true;
    group = "mediarr";
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/mnt/music";
    };
    user = "mediarr";
  };
}
