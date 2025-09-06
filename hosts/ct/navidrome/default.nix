{
  imports = [
    ../../../modules/common/mediarr.nix
  ];

  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings.Address = "0.0.0.0";
  };
}
