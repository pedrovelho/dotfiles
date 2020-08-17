# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.47.2";
      sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
  }];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
in
{
  # Options fo Dell XPS 15
  # https://github.com/NixOS/nixos-hardware/tree/master/dell/xps/15-9560
  # https://gist.github.com/fikovnik/f9d5283689d663d162d79c061774f79b
  imports = [ # Include the results of the hardware scan.
    <nixos-hardware/dell/xps/15-9560/intel>
    ./hardware-configuration.nix
    ./users.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bluetooth support
  boot.kernelParams = [
    "btusb"
    "acpi_rev_override=1"
  ];

  # Accept non free packages, needed for skype, zoom, unrar, etc...
  nixpkgs.config.allowUnfree = true;
  
  programs.zsh.enable = true;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      nerdfonts
    ];
  };

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
  console = {
     font = "Fura Code Regular Nerd Font Complete Mon";
     keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vscode
    vscode-with-extensions

    zerotierone

    # Non free, need allowUnfree set to true
    zoom-us
    unrar
    skype

    # Sanofi
    citrix_workspace
    chromium

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

    # Java
    maven
    jdk

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
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    mediainfo # audio and video

    # Gnome stuff
    gnomeExtensions.system-monitor
    gnome3.evolution
    gnome3.gnome-tweaks
    evolution-data-server
    
    # KDE stuff
    kdeApplications.spectacle

    # Web
    firefox
    chrome-gnome-shell
    nodejs-12_x

    # Dictionnaries
    aspellDicts.fr
    aspellDicts.en
    aspellDicts.pt_BR

    # Message and RSS
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
    mkpasswd

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

    # Gtk
    transmission-gtk
    qt5.full

    # Day to day use in Ryax
    cachix
    kubernetes-helm
    kubectl
    k9s
    pssh

    # Editors
    emacs
    vim

    # Web Site
    hugo

    # Misc
    cloc
    jq
    qemu

    # Printers
    saneBackends
    samsungUnifiedLinuxDriver

    # Fun
    fortune
    sl
    wesnoth-dev
    docker-compose
    sshfsFuse

    # Dell XPS 15 specific
    xorg.xbacklight
  ];

  environment.etc = {
    "hosts".text = "10.161.1.235 Canonceecf2.local\n";
  };
 
  programs.light.enable = true;

  # Enable docker on boot
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  }; 
 
  networking.hostName = "fox";
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "intl";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable graphical login and desktop
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
    displayManager.defaultSession = "gnome";
  };
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # users.extraGroups.vboxusers.members = [ "velho" ];
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = ["a13d7a0e59ae6de4"];
  };
}

