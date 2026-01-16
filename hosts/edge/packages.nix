{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty # to be able to copy term info
  ];
}
