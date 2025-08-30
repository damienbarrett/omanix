# home.nix
{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # fonts (so Waybar icons render)
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # CLI basics
    bash-completion bat btop curl eza fastfetch fd fzf git gh inetutils jq
    lazygit less man nushell plocate ripgrep neovim tldr unzip whois yazi zoxide

    # Wayland / Hyprland helpers
    wl-clipboard grim slurp swaybg xdg-utils

    # terminals
    foot xterm

    # extra icon glyphs for Waybar menu icon etc.
    # does the below overwrite the system font option?
    # nerd-fonts.symbols-only
  ];

  # apps/services used in the session
  programs.wofi.enable = true;
  programs.ghostty.enable = true;
  programs.chromium.enable = true;
  services.mako.enable = true;
  services.lxqt-policykit-agent.enable = true;

  # Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      # monitor = ",highres,auto,2"; # changed to highres from auto
      monitor = ",highres,auto,3"; # changed to highres from auto
      # monitor = ",2560x1600@59.99Hz,auto,2"; # changed to highres from auto

      exec-once = [
        "waybar"
        "swaybg -i /run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
      ];

      bind = [
        # Main terminal (stable in VMs: force X11 + cairo)
        "$mod, Return, exec, env -u WAYLAND_DISPLAY GDK_BACKEND=x11 GDK_GL=disable GSK_RENDERER=cairo ${pkgs.ghostty}/bin/ghostty"

        # Backups
        "$mod SHIFT, Return, exec, ${pkgs.foot}/bin/foot"
        ", F12, exec, ${pkgs.xterm}/bin/xterm -geometry 100x30+40+40"

        # Launchers
        "$mod, D, exec, ${pkgs.wofi}/bin/wofi --show drun"
        ", F10, exec, ${pkgs.wofi}/bin/wofi --show drun"

        # Window mgmt
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, F, fullscreen,"
      ];
    };
  };

  # Waybar with a clickable "Menu" button (left side) + simple pill theme
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      modules-left   = [ "custom/menu" "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" "cpu" "memory" "battery" ];

      "custom/menu" = {
        "format" = "Menu";                         # swap to an icon later (e.g. "")
        "tooltip" = false;
        "on-click" = "${pkgs.wofi}/bin/wofi --show drun";
        "on-click-right" = "${pkgs.wofi}/bin/wofi --show run";
      };

      clock = { "format" = "{:%a %b %d  %H:%M}"; "tooltip" = false; };

      pulseaudio = {
        "format" = "{icon} {volume}%";
        "format-muted" = "";
        "format-icons" = { "headphones" = ""; "default" = [ "" "" "" ]; };
        "tooltip" = true;
      };

      network = {
        "format-wifi" = " {signalStrength}%";
        "format-ethernet" = "󰈀 {ifname}";
        "format-disconnected" = "󰖪";
        "tooltip" = true;
      };

      cpu    = { "format" = " {usage}%"; "tooltip" = true; };
      memory = { "format" = " {used:0.1f}GiB"; "tooltip" = true; };

      battery = {
        "format" = "{icon} {capacity}%";
        "format-charging" = " {capacity}%";
        "format-icons" = [ "" "" "" "" "" ];
        "tooltip" = true;
      };
    }];

    style = ''
      * { border: none; font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", monospace; font-size: 12.5px; color: #cdd6f4; }
      window#waybar { background: rgba(18,20,28,0.85); border-bottom: 1px solid rgba(255,255,255,0.05); }
      #custom-menu, #clock, #pulseaudio, #network, #cpu, #memory, #battery {
        padding: 6px 10px; margin: 4px 6px; background: #1e1e2e; border-radius: 12px;
      }
      #custom-menu { font-weight: 600; }
      #workspaces button { padding: 4px 10px; margin: 4px 4px; background: transparent; color: #a6adc8; border-radius: 10px; }
      #workspaces button.active { background: #313244; color: #cdd6f4; }
      #workspaces button:hover { background: #26283a; }
      #pulseaudio.muted, #network.disconnected { opacity: .6; }
      #battery.charging { background: #a6e3a1; color: #11111b; }
      #battery.warning, #battery.critical { background: #f38ba8; color: #11111b; }
    '';
  };

  xdg.enable = true;

}
