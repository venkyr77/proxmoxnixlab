{exports}: {
  fileSystems = builtins.listToAttrs (
    map (export: {
      name = "/export/${export}";
      value = {
        inherit (exports.${export}) device;
        options = ["bind"];
      };
    })
    (builtins.attrNames exports)
  );

  networking.firewall = {
    allowedTCPPorts = [111 2049 4000 4001 4002 20048];
    allowedUDPPorts = [111 2049 4000 4001 4002 20048];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export 10.0.0.0/24(rw,fsid=0,no_subtree_check)
      ${
        builtins.concatStringsSep "\n" (
          map
          (export: "/export/${export} 10.0.0.0/24(rw,nohide,insecure,no_subtree_check)")
          (builtins.attrNames exports)
        )
      }
    '';
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };
}
