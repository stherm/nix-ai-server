{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.core.nixosModules.print-server ];
  services.print-server = {
    enable = true;
    openFirewall = true;
    reverseProxy.enable = false;
  };

  # Override tempDir to default to fix hpfax/cups crashes
  services.printing.tempDir = lib.mkForce "/tmp";

}
