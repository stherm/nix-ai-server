{ outputs, ... }:

{
  imports = [
    ./comfyui-docker.nix
    ./nginx.nix
    ./ollama.nix
    ./openssh.nix
    ./postgres.nix

    # ./nixified-ai.nix

    # outputs.nixosModules.tailscale
  ];
}
