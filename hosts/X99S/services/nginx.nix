{ inputs, ... }:

let
  tailnet = builtins.fromJSON (builtins.readFile ../../../tailnet.json);
in
{
  imports = [ inputs.core.nixosModules.nginx ];

  services.nginx = {
    enable = true;
    # forceSSL = false; # steffen.fail needs SSL
    commonHttpConfig = ''
      set_real_ip_from ${tailnet.hosts.edge.address};
      real_ip_header X-Forwarded-For;
      real_ip_recursive on;
    '';
  };
}
