{ inputs, config, ... }:

let
  cfg = config.services.jirafeau;
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;

  utils = import ../../../lib/utils.nix;
in
{
  imports = [ inputs.core.nixosModules.jirafeau ];

  services.jirafeau = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "share";
      forceSSL = false;
    };
  };

  services.nginx.virtualHosts."${fqdn}" =
    utils.mkInternalReverseProxy
      tailnet.hosts."${config.networking.hostName}".address;
}
