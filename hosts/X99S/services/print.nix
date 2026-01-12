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

}
