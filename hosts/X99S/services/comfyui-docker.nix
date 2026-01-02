{ outputs, ... }:

{
  imports = [
    outputs.nixosModules.comfyui-docker
  ];

  services.comfyui-docker = {
    enable = true;
    image = "sombi/comfyui:base-torch2.8.0-cu126";
  };
}
