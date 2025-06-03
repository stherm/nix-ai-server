{ config, lib, ... }:

let
  cfg = config.services.ollama;

  inherit (lib) mkDefault mkIf;
in
{
  config = mkIf cfg.enable {
    services.ollama = {
      user = mkDefault "ollama";
      group = mkDefault "ollama";
      acceleration = mkDefault "cuda";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.models} 0755 ${cfg.user} ${cfg.group} -"
    ];
  };
}
