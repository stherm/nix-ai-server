{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    core.gitingest
    dotnetCorePackages.dotnet_8.runtime
    dotnetCorePackages.sdk_8_0_3xx
  ];
}
