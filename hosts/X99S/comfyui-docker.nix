{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.comfyui-docker;
in
{
  options.services.comfyui-docker = {
    enable = lib.mkEnableOption "ComfyUI via somb1/ComfyUI-Docker (Docker/OCI)";

    image = lib.mkOption {
      type = lib.types.str;
      default = "sombi/comfyui:base-torch2.8.0-cu126";
      description = "Docker image tag (siehe somb1/ComfyUI-Docker README).";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/comfyui-docker";
      description = "Persistenter Host-Ordner der nach /workspace gemountet wird.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Bind-Adresse für den ComfyUI Web-Port.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Host-Port für ComfyUI (Container-Port ist 3000).";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        TIME_ZONE = "Europe/Berlin";
      };
      description = "Environment-Variablen für den Container.";
    };

    enableGpu = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "NVIDIA GPU per CDI an den Container durchreichen.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    hardware.nvidia-container-toolkit.enable = lib.mkIf cfg.enableGpu true;

    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers.comfyui = {
      image = cfg.image;
      autoStart = true;

      ports = [
        "${cfg.host}:${toString cfg.port}:3000"
      ];

      volumes = [
        "${toString cfg.dataDir}:/workspace"
      ];

      environment = cfg.environment;

      extraOptions = lib.optionals cfg.enableGpu [
        "--device=nvidia.com/gpu=all"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${toString cfg.dataDir} 0755 root root - -"
    ];

  };
}
