# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Accept non free packages, needed for skype for instance
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # UEFI with anti-freeze on Dell XPS 15
  boot.blacklistedKernelModules = [ "nouveau" "bbswitch" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      nerdfonts
    ];
  };
  hardware.bumblebee.enable = true;
  hardware.bumblebee.pmMethod = "none";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  hardware.bluetooth.enable = true;
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Fura Code Regular Nerd Font Complete Mon";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
   time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zoom-us    
    vim
    # nix_utils
    nix-prefetch-scripts
    nix-zsh-completions
    # monitoring
    psmisc
    pmutils
    nmap
    htop
    usbutils
    iotop
    stress
    tcpdump
    lsof
    # files
    file
    tree
    ncdu
    unzip
    # unrar #NOT FREE need allowUnfree set to true
    # tools
    zsh
    tmux
    ranger
    # ranger previews
    libcaca   # video
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    mediainfo # audio and video
    # Gnome stuff
    gnomeExtensions.system-monitor
    gnome3.evolution
    evolution-data-server

    # Web
    firefox
    chrome-gnome-shell
    # Dictionnaries
    aspellDicts.fr
    aspellDicts.en
    # Message and RSS
    skype
    gnome3.polari
    liferea

    # Media
    vlc
    # Utils
    gnome3.gnome-disk-utility
    xorg.xkill
    wireshark-qt
    git-cola
    gitg
    # storage
    ntfs3g
    exfat
    parted
    hdparm
    sysstat
    gsmartcontrol
    linuxPackages.perf
    # Password
    gnupg
    rofi-pass

    # Graphic tools
    gcolor3
    graphviz
    imagemagick
    inkscape
    #libreoffice-fresh
    gimp
    gitAndTools.gitFull
    python3
    python37Packages.glances
    gcc
    ctags
    gnumake
    wget
    cmake
    gdb
    direnv
    entr
    pandoc
    socat
    # Day to day use in Ryax
    cachix
    kubernetes-helm
    kubectl
    k9s
    pssh
    # Editors
    emacs
    # Web Site
    hugo
    # Misc
    cloc
    jq
    qemu
    # printers
    saneBackends
    samsungUnifiedLinuxDriver
    # fun
    fortune
    sl
    wesnoth-dev
    docker-compose
  ];

  # Enable docker on boot
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  }; 

  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  
  networking.hostName = "fox";
  networking.networkmanager.enable = true;

  services.logind.extraConfig = "
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=suspend
  ";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "intl";
    xkbOptions = "eurosign:e";
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pvelho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

