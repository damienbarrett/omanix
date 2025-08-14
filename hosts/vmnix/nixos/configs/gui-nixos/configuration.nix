{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # >>> CHANGED: Home Manager comes from flake input in flake.nix:
      # >>> CHANGED:   home-manager.nixosModules.home-manager
      # >>> CHANGED: No tarball fetch/import here.
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
  # users.users.nixos = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [ tree ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
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

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
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

    programs.nixvim = {
      enable = true;
      plugins.oil.enable = true;
      plugins.harpoon.enable = true;
      plugins.harpoon.settings = { save_on_toggle = true; };
      extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ]; # for oil icons
      keymaps = [
        { mode = "n"; key = "-"; action = "<cmd>Oil<cr>"; options.desc = "Oil: parent dir"; }
        { mode = "n"; key = "<leader>ha";
          lua = "require('harpoon.mark').add_file()"; options.desc = "Harpoon: add file"; }
        { mode = "n"; key = "<leader>hm";
          lua = "require('harpoon.ui').toggle_quick_menu()"; options.desc = "Harpoon: menu"; }
      ];

	};

    programs.bash.enable = true;   # or programs.zsh.enable = true;
    programs.git.enable  = true;
  };

  # Optional: make HM reuse the same nixpkgs as the system and install into the user profile.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
