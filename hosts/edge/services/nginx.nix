{
  inputs,
  ...
}:

let
  vHosts =
    let
      domain = "synapse-test.ovh";
      X99S = "100.64.0.3";
    in
    [
      {
        fqdn = "git." + domain;
        host = X99S;
        port = "3001";
      }
    ];

  mkVHost = host: port: {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${host}:${port}";
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
    virtualHosts = mkVHosts vHosts;
  };
}
