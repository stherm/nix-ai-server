{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.common
    inputs.core.nixosModules.sops

    outputs.nixosModules.common

    ./boot.nix
    ./comfyui-docker.nix
    ./hardware.nix
    #./nixified-ai.nix
    ./packages.nix
    ./postgres.nix
    ./services.nix
    ./users.nix
  ];

  services.comfyui-docker.enable = true;
  services.comfyui-docker.image = "sombi/comfyui:base-torch2.8.0-cu126";

  networking.hostName = "X99S";
  networking.domain = "steffen.fail";

  system.stateVersion = "24.11";
}
