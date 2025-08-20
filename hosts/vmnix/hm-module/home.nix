# home.nix
{ config, pkgs, ... }:

{
  # Minimum required by Home Manager:
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";  # pick the version you first start with; don't bump casually
}
