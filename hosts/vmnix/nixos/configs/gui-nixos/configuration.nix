{ config, lib, pkgs, ... }:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix
  ];

  ########################################
  # Boot
  ########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ########################################
  # Host & locale
  ########################################
  networking.hostName = "vmnixos";
  time.timeZone = "Europe/Amsterdam";

  ########################################
  # System packages (CLI tools, editors, etc.)
  ########################################
  environment.systemPackages = with pkgs; [
    vim wget
    bash-completion bat btop curl eza fastfetch fd fzf git gh inetutils less jq
    lazygit man nushell plocate ripgrep neovim tldr unzip whois yazi zoxide
  ];

  ########################################
  # Programs & services
  ########################################
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  ########################################
  # Nix features
  ########################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ########################################
  # Users
  ########################################
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # sudo
    packages = with pkgs; [ tree ];
  };

  ########################################
  # Home Manager (user-scoped config)
  ########################################
  home-manager.users.nixos = { pkgs, ... }: {
    home.username = "nixos";
    home.homeDirectory = "/home/nixos";
    home.stateVersion = "25.05"; # HM’s own compatibility knob

    # Put Home-Manager modules here (never at system level)
    imports = [
      ./wrappers/hm.nix
    ];

    # NixVim configured declaratively (Oil + Harpoon)
    programs.nixvim = {
      enable = true;

      # Plugin modules
      plugins.oil.enable = true;        # stevearc/oil.nvim
      plugins.harpoon.enable = true;    # ThePrimeagen/harpoon

      # Your keymaps use Harpoon v1 APIs; pin v1 to match
      plugins.harpoon.package = pkgs.vimPlugins.harpoon;

      # Dependencies / UX niceties
      extraPlugins = [
        pkgs.vimPlugins.plenary-nvim        # required by Harpoon v1
        pkgs.vimPlugins.nvim-web-devicons   # optional icons for Oil
      ];

      # Handy keymaps (Oil & Harpoon v1)
      keymaps = [
        { mode = "n"; key = "-";            action = "<cmd>Oil<cr>";                                   options.desc = "Oil: parent dir"; }
        { mode = "n"; key = "<leader>ha";   lua = "require('harpoon.mark').add_file()";               options.desc = "Harpoon add file"; }
        { mode = "n"; key = "<leader>he";   lua = "require('harpoon.ui').toggle_quick_menu()";        options.desc = "Harpoon menu"; }
        { mode = "n"; key = "<leader>h1";   lua = "require('harpoon.ui').nav_file(1)";                options.desc = "Harpoon 1"; }
        { mode = "n"; key = "<leader>h2";   lua = "require('harpoon.ui').nav_file(2)";                options.desc = "Harpoon 2"; }
        { mode = "n"; key = "<leader>h3";   lua = "require('harpoon.ui').nav_file(3)";                options.desc = "Harpoon 3"; }
        { mode = "n"; key = "<leader>h4";   lua = "require('harpoon.ui').nav_file(4)";                options.desc = "Harpoon 4"; }
      ];
    };

    # Other HM-managed programs
    programs.bash.enable = true;
    programs.git.enable  = true;
  };

  ########################################
  # State version pins
  ########################################
  system.stateVersion = "25.05"; # NixOS compatibility anchor (separate from HM’s)
}
