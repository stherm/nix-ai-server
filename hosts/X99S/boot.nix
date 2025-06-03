{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };

    efi.canTouchEfiVariables = false;

    efi.efiSysMountPoint = "/boot";

  };
}
