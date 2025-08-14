{ config, lib, pkgs, ... }:

let # home-manager
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/refs/heads/release-25.05.tar.gz";
    sha256 = "sha256-oV695RvbAE4+R9pcsT9shmp6zE/+IZe6evHWX63f2Qg=";
  };


in # home-manager
{
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos") # home-manager
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vmnixos";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   #users.users.nixos = {
     #isNormalUser = true;
     #extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     #packages = with pkgs; [
       #tree
     #];
   #};

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim
     wget

	# Shell packages
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
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

   services.openssh.enable = true; # Enable the OpenSSH daemon.

  system.stateVersion = "25.05"; # Do not change, even when upgrading

  # NEW THINGS

  # Enable experimental features such as flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configuration

  time.timeZone = "Europe/Amsterdam";

  users.users.nixos.isNormalUser = true;
  users.users.nixos.extraGroups = [ "wheel" ]; 
  users.users.nixos.packages = with pkgs; [ tree ];

  # Home Manager for user "nixos"
  home-manager.users.nixos = { pkgs, ... }: {
    home.username = "nixos";
    home.homeDirectory = "/home/nixos";
    home.stateVersion = "25.05";  # must be set; keep it when updating HM

    # example: move per-user tools here over time
    home.packages = with pkgs; [
      neovim
    ];

    programs.bash.enable = true;   # or programs.zsh.enable = true;
    programs.git.enable  = true;
  };

  # Optional: make HM reuse the same nixpkgs as the system and install into the user profile.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

}
