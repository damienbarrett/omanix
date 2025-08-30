{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vmnixos"; 

  # time.timeZone = "Europe/Amsterdam";

  # i18n/default locale, console, X11 left as-is (commented)

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [

    # system utilities
    vim
    wget

    # desktop environment
    wlr-randr
    wayland-utils
    xorg.xrdb
    pciutils

    # drivers and utilities
    mesa-demos
    open-vm-tools
  ];

  # VMware guest integration
  virtualisation.vmware.guest.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

  # NEW THINGS

  # Enable experimental features such as flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.download-buffer-size = 268435456;

  # Hyprland system integration (session file, polkit, xdp, xwayland, etc.)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # login/greeter

  services.greetd = {
    enable = true;
  };

  programs.regreet.enable = true;

  hardware.graphics.enable = true;

  # XDG portals (screensharing, file pickers) for Hyprland
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
  };

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  # Waybar Fonts
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.monaspace
  ];

  # VMware + wlroots env vars for 
  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    XWAYLAND_NO_GLAMOR = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
  };

  boot.kernelModules = [ "vmwgfx" ];
  services.xserver.videoDrivers = [ "vmware" "modesetting" ];

  nixpkgs.overlays = [ (import ./overlays/mesa-svga.nix) ];
}
