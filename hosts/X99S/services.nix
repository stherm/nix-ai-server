{
  inputs,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.ollama
    # inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh

    # outputs.nixosModules.open-webui-oci
  ];

  services = {
    nginx.enable = true;

    ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:14b"
        "gemma3:12b"
        "gemma3:27b"
        "gemma3:27b-it-qat"
        "mistral:7b"
        "qwen3:14b"
      ];
    };

    open-webui = {
      # enable = true; # FIXME: rapidocr-onnxruntime-1.4.4 fails to build with exit code 134
      package = pkgs.stable.open-webui;
    };
  };

}
