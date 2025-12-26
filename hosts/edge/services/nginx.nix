{
  inputs,
  config,
  lib,
  ...
}:

let
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  domain = tailnet.hosts.edge.publicDomain;
  X99S = tailnet.hosts.X99S.address;

  inherit (lib.utils) mkVirtualHost;
in
{
  imports = [ inputs.core.nixosModules.nginx ];

  services.nginx = {
    enable = true;
    forceSSL = true;
    openFirewall = true;
    virtualHosts = {
      "cloud.${domain}" = mkVirtualHost {
        inherit config;
        fqdn = "cloud.${domain}";
        address = X99S;
        port = 80;
      };
      "git.${domain}" = mkVirtualHost {
        inherit config;
        fqdn = "git.${domain}";
        address = X99S;
        port = 80;
      };
      "share.${domain}" = mkVirtualHost {
        inherit config;
        fqdn = "share.${domain}";
        address = X99S;
        port = 80;
      };
    };
  };
}
