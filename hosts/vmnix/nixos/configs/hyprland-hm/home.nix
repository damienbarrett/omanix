# home.nix
{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    bash-completion bat btop curl eza fastfetch fd fzf git gh inetutils less jq
    lazygit man nushell plocate ripgrep neovim tldr unzip whois yazi zoxide

    # Wayland/Hyprland helpers + backup terminals
    wl-clipboard grim slurp swaybg xdg-utils
    foot xterm
  ];

  # Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "lxqt-policykit-agent"
        "mako"
        "swaybg -i /run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
      ];

      bind = [
        "$mod, Return, exec, ghostty"   # main terminal
        ", F12, exec, xterm"            # rescue terminal (no modifiers)
        "$mod, D, exec, wofi --show drun"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, F, fullscreen,"
      ];
    };
  };

  # Waybar with a clickable "Menu" button
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      modules-left = [ "custom/menu" "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" ];

      "custom/menu" = {
        "format" = "Menu";               # change to an icon later if you want
        "tooltip" = false;
        "on-click" = "wofi --show drun"; # mouse-friendly app launcher
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

  # (Optional) If you still want fuzzel, uncomment:
  # programs.fuzzel.enable = true;
}
