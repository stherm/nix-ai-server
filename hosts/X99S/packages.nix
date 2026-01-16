{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnetCorePackages.dotnet_8.runtime
    dotnetCorePackages.sdk_8_0_3xx
    gh
    tmux
    kitty
  ];
}
