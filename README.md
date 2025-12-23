# NixOS configurations for `steffen.fail`

This repository is a collection of NixOS configurations powered by [*nix-core*](https://github.com/sid115/nix-core).

## Deployment

Deploy hosts in this flake according to [`deploy.json`](./deploy.json):

```bash
nix run github:sid115/nix-core#apps.x86_64-linux.deploy
```

SSH needs to be able to resolve all hostnames that will be deployed. Add this to your Home Manager config:

```nix
{
  programs.ssh.matchBlocks = {
    edge = {
      host = "e edge";
      hostname = "synapse-test.ovh";
      port = 2299;
      user = "YOU";
    };
    X99S = {
      host = "X X99S";
      hostname = "steffen.fail";
      port = 2299;
      user = "YOU";
    };
  };
}
```
