{ outputs, ... }:

{
  imports = [
    ./comfyui-docker.nix
    ./gitea.nix
    ./github-runners.nix
    ./jirafeau.nix
    # ./nextcloud.nix
    ./nginx.nix
    ./ollama.nix
    ./openssh.nix
    ./postgres.nix

    outputs.nixosModules.tailscale
  ];
}
