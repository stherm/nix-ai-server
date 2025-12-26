{ inputs, lib, ... }:

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
    hostName = mkForce fqdn;
    settings = {
      mail_domain = domain;
      mail_smtphost = "mail." + domain;
      mail_smtpname = "nextcloud@" + domain;
    };
  };
}
