# Home-Manager module: import ONLY inside home-manager.users.<name>
{ config, lib, pkgs, ... }:

{
  # Example user-scoped packages
  home.packages = with pkgs; [
    htop
  ];

  programs.zoxide.enable = true;
  programs.fzf.enable = true;

  # Example session env
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
