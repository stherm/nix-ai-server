{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixified-ai.nixosModules.comfyui
  ];

  nix.settings = {
    trusted-substituters = [ "https://ai.cachix.org" ];
    trusted-public-keys = [
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];
  };

  services.comfyui = {
    enable = true;
    package = inputs.nixified-ai.packages.${pkgs.system}.comfyui-nvidia; # package in overlay?
    host = "0.0.0.0";
    # models = builtins.attrValues pkgs.nixified-ai.models; # requires HF_TOKEN and CIVITAI_API_TOKEN
    customNodes = with pkgs.comfyuiPackages; [
      comfyui-gguf
      # comfyui-impact-pack # does not build
    ];
  };
}
