{
  inputs,
  ...
}:

let
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);

  vHosts =
    let
      domain = tailnet.hosts.edge.publicDomain;
      X99S = tailnet.hosts.X99S.address;
    in
    [
      {
        fqdn = "git." + domain;
        host = X99S;
      }
      # {
      #   fqdn = "cloud." + domain;
      #   host = X99S;
      # }
      {
        fqdn = "share." + domain;
        host = X99S;
      }
    ];

  mkVHost = host: port: {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${host}:80";
      proxyWebsockets = true;
    };
  };

  mkVHosts =
    vHosts:
    builtins.listToAttrs (
      map (vHost: {
        name = vHost.fqdn;
        value = mkVHost vHost.host vHost.port;
      }) vHosts
    );
in
{
  imports = [ inputs.core.nixosModules.nginx ];

  services.nginx = {
    enable = true;
    forceSSL = true;
    openFirewall = true;
    virtualHosts = mkVHosts vHosts;
  };
}
