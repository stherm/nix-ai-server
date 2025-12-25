{ inputs, config, ... }:

let
  cfg = config.services.gitea;
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  fqdn = cfg.reverseProxy.subdomain + "." + tailnet.hosts.edge.publicDomain;

  utils = import ../../../lib/utils.nix;
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

  services.nginx.virtualHosts."${fqdn}" =
    utils.mkInternalReverseProxy tailnet.hosts."${config.networking.hostName}".address
    // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.server.HTTP_PORT}";
        # DEBUG
        extraConfig = ''
          add_header X-Debug-Source "INTERNAL-SERVER" always;
        '';
      };
    };
}
