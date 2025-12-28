{
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.gitea;
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;

  inherit (lib.utils)
    mkVirtualHost
    ;
in
{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea = {
    enable = true;
    settings.server = {
      DOMAIN = fqdn; # hotfix to override `steffen.fail`
      ROOT_URL = "http://${fqdn}/"; # hotfix to override `steffen.fail`
      HTTP_ADDR = "127.0.0.1"; # hotfix to override `steffen.fail`
      HTTP_PORT = 3001;
    };
    reverseProxy.enable = false; # hotfix to override `steffen.fail`
  };

  services.nginx.virtualHosts."${fqdn}" =
    # hotfix to override `steffen.fail`
    mkVirtualHost {
      inherit config fqdn;
      port = cfg.settings.server.HTTP_PORT;
      ssl = false;
    }
    // {
      listen = [
        {
          addr = tailnet.hosts."${config.networking.hostName}".address;
          port = 80;
        }
      ];
    };

  # hotfix to override `steffen.fail`
  security.acme.certs = {
    "${fqdn}".postRun = "systemctl restart gitea.service";
  };
}
