{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # core.marker-pdf
    dotnetCorePackages.dotnet_8.runtime
    dotnetCorePackages.sdk_8_0_3xx
    gitingest
    tmux
  ];
}
