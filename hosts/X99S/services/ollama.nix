{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.ollama
  ];

  services.ollama = {
    enable = false;
    loadModels = [
      "deepseek-r1:14b"
      "gemma3:12b"
      "gemma3:27b"
      "gemma3:27b-it-qat"
      "gpt-oss:20b"
      "mistral:7b"
      "qwen3:14b"
    ];
  };
}
