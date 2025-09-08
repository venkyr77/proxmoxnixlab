{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-ffmpeg
    pkgs.jellyfin-web
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
