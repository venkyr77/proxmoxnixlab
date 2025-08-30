{props, ...}: {
  image.baseName = "nixos";
  users.users.ops.openssh.authorizedKeys.keys = props.common_config.authorized_keys;
}
