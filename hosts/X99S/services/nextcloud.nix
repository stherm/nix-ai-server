{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
  domain = tailnet.hosts.edge.publicDomain;
  subdomain = "cloud";
  fqdn = subdomain + "." + domain;

  inherit (lib) mkForce;
in
{
  imports = [ inputs.core.nixosModules.nextcloud ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = mkForce fqdn;
    reverseProxy = {
      enable = true;
      forceSSL = false;
      inherit subdomain;
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    sslCertificate = mkForce "/dev/null";
    sslCertificateKey = mkForce "/dev/null";
  };
}
