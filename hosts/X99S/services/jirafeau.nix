{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.jirafeau ];

  services.jirafeau = {
    enable = true;
    dataDir = "/data/jirafeau";
    nginxConfig = {
      enableACME = false;
      forceSSL = false;

      serverName = "share.synapse-test.ovh";

      listen = [
        { addr = "100.64.0.3"; port = 3002; }
      ];
    };
  };
}
