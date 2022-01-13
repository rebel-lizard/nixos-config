# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/697cc8c68ed6a606296efbbe9614c32537078756.tar.gz";
    sha256 = "1c8gxm86zshr2zj9dvr02qs7y3m46gqavr6wyv01r09jfd99dxz9";     
  };

  vim = pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig = {
      packages.myVimPackage.start = [
        pkgs.vimPlugins.nerdtree
	pkgs.vimPlugins.vim-nix
      ];
      customRC = ''
        syntax on
	set nocompatible
        set number
        set relativenumber
        set hidden
        set colorcolumn=80
        set smartindent 
           
	" hot keys
	let mapleader = '\'
        nnoremap <leader>n :NERDTreeFocus<CR>
        nnoremap <leader>fn :NERDTreeFind<CR>
      '';
    }; 
  };
in

{
  imports = [
    (import "${home-manager}/nixos")     
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # The same as above:
  # boot = {
  #   loader = {
  #     efi = {
  #       canTouchEfiVariables = true;
  #     };
  #     systemd-boot = {
  #       enable = true;
  #     };      
  #   };
  # };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ilias = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
   
  home-manager.users.ilias = {
    programs.git = {
      enable = true;
      userName = "Ilias Indrali";
      userEmail = "ilias.indrali@gmail.com";
    };
  };    

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    vim
    pkgs.wget
    pkgs.curl
    pkgs.git
    pkgs.firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

