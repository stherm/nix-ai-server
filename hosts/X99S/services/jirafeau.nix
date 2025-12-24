{ inputs, config, ... }:

let
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  cfg = config.services.jirafeau;
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;
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
    

    nginxConfig = {
      enableACME = false;
      forceSSL = false;

      listen = [
        {
          addr = tailnet.hosts."${config.networking.hostName}".address;
          port = 80;
        }
      ];
    };

  };

}

