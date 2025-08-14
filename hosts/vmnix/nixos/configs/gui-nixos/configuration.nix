{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Host & locale
  networking.hostName = "vmnixos";
  time.timeZone = "Europe/Amsterdam";

  # Shell / CLI tools
  environment.systemPackages = with pkgs; [
    vim wget
    bash-completion bat btop curl eza fastfetch fd fzf git gh inetutils less jq
    lazygit man nushell plocate ripgrep neovim tldr unzip whois yazi zoxide
  ];

  # GnuPG agent with SSH support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # SSH server
  services.openssh.enable = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User (remember to set a password with `sudo passwd nixos`)
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # sudo
    packages = with pkgs; [ tree ];
  };

  # ---- Home Manager (provided by flake input) ----
  # Per-user config for "nixos".
  home-manager.users.nixos = { pkgs, ... }: {
    home.username = "nixos";
    home.homeDirectory = "/home/nixos";
    home.stateVersion = "25.05"; # keep once set; controls HM defaults

    programs.nixvim = {
      enable = true;

      plugins.oil.enable = true;       # stevearc/oil.nvim
      plugins.harpoon.enable = true;   # ThePrimeagen/harpoon

      # Nice-to-have icons for Oil listings
      extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];

      # Handy keymaps (Oil & Harpoon)
      keymaps = [
        { mode = "n"; key = "-"; action = "<cmd>Oil<cr>"; options.desc = "Oil: parent dir"; }
        { mode = "n"; key = "<leader>ha"; lua = "require('harpoon.mark').add_file()"; options.desc = "Harpoon add file"; }
        { mode = "n"; key = "<leader>he"; lua = "require('harpoon.ui').toggle_quick_menu()"; options.desc = "Harpoon menu"; }
        { mode = "n"; key = "<leader>h1"; lua = "require('harpoon.ui').nav_file(1)"; options.desc = "Harpoon 1"; }
        { mode = "n"; key = "<leader>h2"; lua = "require('harpoon.ui').nav_file(2)"; options.desc = "Harpoon 2"; }
        { mode = "n"; key = "<leader>h3"; lua = "require('harpoon.ui').nav_file(3)"; options.desc = "Harpoon 3"; }
        { mode = "n"; key = "<leader>h4"; lua = "require('harpoon.ui').nav_file(4)"; options.desc = "Harpoon 4"; }
      ];
    };

    # You can add more HM-managed programs here (bash/zsh/git/etc.)
    programs.bash.enable = true;
    programs.git.enable  = true;
  };

  # Pin once at install; don’t duplicate this elsewhere.
  system.stateVersion = "25.05";  
}
