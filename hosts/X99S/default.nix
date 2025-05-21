{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.common
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.normalUsers
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh

    outputs.nixosModules.common
    outputs.nixosModules.nvidia

    ./boot.nix
    ./hardware.nix
    ./packages.nix
  ];

  networking.hostName = "X99S";
  networking.domain = "steffen.fail";

  services.postgresql = {
    settings.port = 5432;
    enable = true;
    settings = {
      #ssl = true;
      #ssl_cert_file = "/var/lib/acme/${config.networking.domain}/cert.pem";
      #ssl_key_file = "/var/lib/acme/${config.networking.domain}/key.pem";
    };
    ensureDatabases = [ "fw_grafschaft" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all       all     trust
      host  all      prosinsky     0.0.0.0/0   scram-sha-256
      host all       prosinsky     ::/0        scram-sha-256
      host  all      postgres     0.0.0.0/0   scram-sha-256
      host all       postgres     ::/0        scram-sha-256
      host  fw_grafschaft      all     0.0.0.0/0   scram-sha-256
      host fw_grafschaft       all     ::/0        scram-sha-256
    '';

  };
  users.users.postgres.extraGroups = [ "nginx" ];
  systemd.services.postgresql.serviceConfig = {
    User = "postgres";
    #SupplementaryGroups = [ "nginx" ];
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];

  services = {
    nginx.enable = true;
    openssh.enable = true;
    ollama = {
      enable = true;
      user = "ollama";
      group = "ollama";
      acceleration = "cuda";
      models = "/data/ollama/models";
      loadModels = [
        "mistral:7b"
        "deepseek-r1:14b"
        "gemma3:12b"
        "qwen3:14b"
      ];
    };
    open-webui = {
      enable = true;
    };

  };

  systemd.tmpfiles.rules =
    let
      o = config.services.ollama;
    in
    [
      "d ${o.models} 0755 ${o.user} ${o.group} -"
    ];

  normalUsers = {
    steffen = {
      name = "steffen";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/steffen/pubkeys/X670E.pub ];
    };
    sid = {
      name = "sid";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
    susagi = {
      name = "susagi";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [ ../../users/susagi/pubkeys/vde_rsa.pub ];
    };
    peter = {
      name = "peter";
      extraGroups = [
        "wheel"
      ];
      sshKeyFiles = [
        ../../users/peter/pubkeys/pc_privat.pub
        ../../users/peter/pubkeys/laptop_privat.pub
      ];
    };
  };
  system.stateVersion = "24.11";
}
