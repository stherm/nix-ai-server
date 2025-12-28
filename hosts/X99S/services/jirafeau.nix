{
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.jirafeau;
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;
in
{
  imports = [ inputs.core.nixosModules.jirafeau ];

  services.jirafeau = {
    enable = true;
    hostName = lib.mkForce fqdn; # hotfix to override `steffen.fail`

    reverseProxy = {
      enable = true;
      subdomain = "share";
      forceSSL = false;
    };

    nginxConfig = {
      serverName = lib.mkForce fqdn; # hotfix to override `steffen.fail`
      listenAddresses = [ tailnet.hosts."${config.networking.hostName}".address ];
      listen = [
        {
          addr = tailnet.hosts."${config.networking.hostName}".address;
          port = 80;
        }
      ];
    };
  };
}
