{ config, pkgs, ... }:

{
  systemd.services.einsatzloader = {
    description = "EinsatzLoader DB 2 (.NET Service)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "peter";
      WorkingDirectory = "/home/peter/net8.0";

      ExecStart = "${pkgs.dotnet-sdk_8}/bin/dotnet /home/peter/net8.0/EinsatzLoader_DB_2.dll";

      Restart = "always";
      RestartSec = 5;
    };
  };
}
