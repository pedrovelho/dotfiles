# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  # Options for Lenovo ThinkPad X1 Gen 3
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ./kill-all-docker-containers.nix
  ];

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "intl";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable graphical login and desktop
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  
  boot = {
    initrd.availableKernelModules = [ "battery" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 1;
  };

  services.fstrim.enable = lib.mkDefault true;
  
  services.throttled.enable = lib.mkDefault true;
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  services.tlp.enable = false;
  
  # Accept non free packages, needed for skype, zoom, unrar, etc...
  nixpkgs.config.allowUnfree = true;
  
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      nerdfonts
    ];
  };

  # Disable explicitely use networkManager instead
  networking.useDHCP = false;
  hardware.bluetooth.enable = true;
  
  # Select internationalisation properties.
  console = {
     font = "Fura Code Regular Nerd Font Complete Mon";
     keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  #browserpass
  programs.browserpass.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Custom scripts
    nvidia-offload

    #pycharm
    jetbrains.pycharm-community

    # Non free, need allowUnfree set to true
    zoom-us
    unrar
    skype

    # Nix utils
    nix-prefetch-scripts
    nix-zsh-completions

    # Monitoring
    psmisc
    pmutils
    nmap
    htop
    usbutils
    iotop
    stress
    tcpdump
    lsof

    # Files
    file
    tree
    ncdu
    unzip
    zip
    p7zip
    
    # Java
    maven
    jdk

    # Password store
    pass

    # Command line extra
    bc
    ffmpeg
    hping
    iftop

    # Tools
    zsh
    tmux
    ranger
    # ranger previews
    libcaca   # video
    jellyfin  # homemade netflix
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    mediainfo # audio and video
    lingot    # guitar tuner
    
    # Gnome stuff
    gnome.gnome-tweaks
    gtop
    libgtop
    rake
    kazam

    # Web
    firefox
    thunderbird
    chrome-gnome-shell
    google-chrome
    nodejs-12_x
    filezilla
    
    # Dictionnaries
    aspell
    aspellDicts.fr
    aspellDicts.en
    aspellDicts.pt_BR
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_US-large
    
    # Message and RSS
    gnome3.polari
    liferea

    # Media
    vlc

    # Utils
    gnome3.gnome-disk-utility
    xorg.xkill
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
    mkpasswd
    pinentry
    
    # Graphic tools
    gnome3.meld
    gcolor3
    graphviz
    imagemagick
    inkscape
    libreoffice
    gimp
    gitAndTools.gitFull
    python3
    glances
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

    # Cloud stuff
    awscli2
    google-cloud-sdk-gce
    rclone

    # PDF
    xournal
    xournalpp

    # Gtk
    transmission-gtk

    # Day to day use in Ryax
    cachix
    kubernetes-helm
    kubectl
    k9s
    pssh

    # Editors
    emacs
    vim

    # Virtualization
    #virtualbox

    # Canon drivers
    canon-cups-ufr2

    # Web Site
    hugo

    # Misc
    cloc
    jq
    qemu
    bind
    eksctl 
    openvpn
    patchelf
    pdftk

    # Printers
    gutenprint
    gutenprintBin
    saneBackends

    # DB
    dbeaver
    mariadb-client
    
    # Fun
    fortune
    sl
    wesnoth-dev
    docker-compose
    sshfsFuse
    skopeo
    
    # Dell XPS 15 specific
    xorg.xbacklight

    # install ifuse
    ideviceinstaller
    ifuse
    libimobiledevice

    # poetry, python package manager
    poetry

    # varzia
    retroarchFull
  ];

  networking.extraHosts =
  ''
    10.161.1.235 Canonceecf2.local
    192.168.68.119 HP947F89.local
    40.69.34.58 keycloak-uaa-01
    192.168.68.107 BRW485F9938749C.local
  '';

  programs.light.enable = true;

  programs.zsh.enable = true;

  # Enable docker on boot
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.ssh.forwardX11 = true;

  # Enable singularity
  programs.singularity.enable = true;

  # List services that you want to enable:
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  }; 

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-nixos";
   
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  users.extraGroups.vboxusers.members = [ "velho" ];

  services.avahi = {
    enable = true;
  };

  programs.steam.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # NVIDIA
  services.xserver.videoDrivers = [ "modeset" "nvidia" ];
  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   # Bus ID of the Intel GPU. You can find it using lspci, VGA Controller
  #   intelBusId = "PCI:0:2:0";
  #   # Bus ID of the NVIDIA GPU. You can find it using lspci 
  #   nvidiaBusId = "PCI:1:0:0";
  # };
  # specialisation = {
  #   external-display.configuration = {
  #     system.nixos.tags = [ "external-display" ];
  #     hardware.nvidia.prime.offload.enable = lib.mkForce false;
  #     hardware.nvidia.powerManagement.enable = lib.mkForce false;
  #   };
  # };
}

