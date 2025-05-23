{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh

    outputs.nixosModules.ollama
  ];

  services = {
    nginx.enable = true;

    openssh.enable = true;

    ollama = {
      enable = true;
      loadModels = [
        "mistral:7b"
        "deepseek-r1:14b"
        "gemma3:12b"
        "qwen3:14b"
      ];
    };

    open-webui.enable = true;
  };
}
