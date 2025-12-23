{ outputs, ... }:

{
  imports = [
    ./comfyui-docker.nix
    ./gitea.nix
    # ./github-runners.nix
    ./nginx.nix
    ./ollama.nix
    ./openssh.nix
    ./postgres.nix

    # ./nixified-ai.nix # FIXME

    outputs.nixosModules.tailscale
  ];
}
