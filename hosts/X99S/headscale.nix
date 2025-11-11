{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;
    settings = {
      server_url = "https://headscale.steffen.fail";
      database.type = "sqlite";
      derp.server.enable = true;
      dns = {
        magic_dns = true;
        base_domain = "headscale.local";
        override_local_dns = false;
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."headscale.steffen.fail" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 3478 ];
  };
}
