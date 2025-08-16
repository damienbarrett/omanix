# home.nix
{ config, pkgs, ... }:

{
  # Minimum required by Home Manager:
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";  # pick the version you first start with; don't bump casually

  home.packages = with pkgs; [
    bash-completion
	bat
	btop
	curl
	eza
	fastfetch
	fd
	fzf
	git
	gh
	inetutils
	less
	jq
	lazygit
	man
	nushell
	plocate
	ripgrep
	neovim
	tldr
	unzip
	whois
	yazi
	zoxide

    # hyprland packages
    wl-clipboard grim slurp swaybg
    xdg-utils
    foot xterm # backup
  ];

  # apps those binds call
  programs.waybar.enable = true;
  programs.fuzzel.enable = true;            # simple Wayland launcher
  programs.kitty.enable = true;

  home.packages = with pkgs; [ wl-clipboard grim slurp ];

  #Hyprland via HM (actual compositor config)
  wayland.windowManager.hyprland = {
    enable = true;
    # systemd target is on by default; keep it (it exports env vars to user services)
    # wayland.windowManager.hyprland.systemd.enable = true;

    settings = {
      "$mod" = "SUPER";
      monitor = ",preferred,auto,1";

      # Start essentials once
      exec-once = [
        "waybar"
        "lxqt-policykit-agent"  # polkit GUI
        "mako"                  # notifications
        "swaybg -i /run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
      ];

      bind = [
        "$mod, Return, exec, kitty"
        # ", F12, exec, kitty"            # keep the no-mod fallback
        "$mod, D, exec, wofi --show drun"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, F, fullscreen,"
        # "$mod, Return, exec, foot"
        ", F12, exec, xterm"    # rescue fallback
      ];
    };
  };

  # Bar
  programs.waybar = {
    enable = true;
    # super-minimal bar
    settings = [{
      layer = "top";
      position = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" ];
      # The "start button"
      "custom/menu" = {
        "format" = "";                 # any icon/text (needs a nerd/FA icon)
        "tooltip" = false;
        "on-click" = "wofi --show drun"; # app launcher (mouse friendly)
        "on-click-right" = "wofi --show run"; # optional: "run" dialog on right-click
      };
    }];
  };

  # Launcher / terminal / notifications
  programs.wofi.enable = true;         # Wayland app launcher
  programs.kitty.enable = true;        # terminal
  services.mako.enable = true;         # notify daemon

  # Polkit agent (so auth prompts appear on Hyprland)
  services.lxqt-policykit-agent.enable = true;

}
