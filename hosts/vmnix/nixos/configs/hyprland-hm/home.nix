# home.nix
{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    bash-completion bat btop curl eza fastfetch fd fzf git gh inetutils less jq
    lazygit man nushell plocate ripgrep neovim tldr unzip whois yazi zoxide

    wl-clipboard grim slurp swaybg xdg-utils
    foot xterm  # backup terms
    xwayland
  ];

  # Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      monitor = ",preferred,auto,1";

      # Start essentials once + a guaranteed terminal
      exec-once = [
        "xterm -geometry 100x30+40+40"  # <-- opens at login so you always have a shell
        "waybar"
        "lxqt-policykit-agent"
        "mako"
        "swaybg -i /run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
      ];

      bind = [
        "$mod, Return, exec, ghostty"   # or kitty/foot if you prefer
        ", F12, exec, xterm"            # rescue: no modifiers
        "$mod, D, exec, wofi --show drun"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, F, fullscreen,"
      ];
    };
  };

  # Waybar with a visible, clickable "Menu" button
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      modules-left = [ "custom/menu" "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" ];

      "custom/menu" = {
        "format" = "Menu";               # switch to an icon later if you want
        "tooltip" = false;
        "on-click" = "wofi --show drun";
        "on-click-right" = "wofi --show run";
      };
    }];
    style = ''
      #custom-menu { padding: 0 12px; font-size: 16px; }
    '';
  };

  # Apps used by binds
  programs.wofi.enable = true;
  programs.ghostty.enable = true;
  services.mako.enable = true;
  services.lxqt-policykit-agent.enable = true;

  # If you also want kitty, add:
  # programs.kitty.enable = true;
}
