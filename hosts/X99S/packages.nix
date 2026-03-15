{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnetCorePackages.dotnet_8.runtime
    dotnetCorePackages.sdk_8_0_4xx
    gh
    tmux
    kitty
  ];
}
