{ inputs, config, ... }:

let
  cfg = config.services.gitea;
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;
in
{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea = {
    enable = true;
    settings.server = {
      HTTP_PORT = 3001;
    };
    reverseProxy = {
      enable = true;
      subdomain = "git";
      forceSSL = false;
    };
  };
}
