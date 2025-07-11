{
  inputs,
  config,
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
    user = "comfyui";
    group = "comfyui";
    host = "0.0.0.0";
    # FIXME: does not build
    #   > Warning: HF_TOKEN is set, but fetching didn't seem to work, check your token!
    #   > Warning: CIVITAI_API_TOKEN is set, but fetching didn't seem to work, check your token!
    # models = builtins.attrValues pkgs.nixified-ai.models;
    customNodes = with pkgs.comfyuiPackages; [
      comfyui-gguf
      # comfyui-impact-pack # does not build
    ];
  };

  systemd.services.nix-daemon.serviceConfig = {
    EnvironmentFile = config.sops.templates."comfyui".path;
  };

  sops =
    let
      owner = config.services.comfyui.user;
      group = config.services.comfyui.group;
      mode = "0440";
    in
    {
      secrets."comfyui/hf-token" = {
        inherit owner group mode;
      };
      secrets."comfyui/civitai-api-token" = {
        inherit owner group mode;
      };
      templates."comfyui" = {
        inherit owner group mode;
        content = ''
          HF_TOKEN=${config.sops.placeholder."comfyui/hf-token"}
          CIVITAI_API_TOKEN=${config.sops.placeholder."comfyui/civitai-api-token"}
        '';
      };
    };
}
