# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
  ])

  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.47.2";
      sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.9.114305";
      sha256 = "1vh0wvfvzszc58lw7dbl60knpm5l6rrsghfchhn5dvwyadx4a33h";
    }
    {
      name = "code-spell-checker";
      publisher = "streetsidesoftware";
      version = "1.9.2";
      sha256 = "17wkhwlnicy9inkv69mlkfz6ws7n6j7wfsnwczkc7dbyfqcz0mdb";
    }
    {
      name = "code-spell-checker-french";
      publisher = "streetsidesoftware";
      version = "0.1.10";
      sha256 = "1rbrsb5wh4mkz1a6kp4pdgcw3c9p9j2c1rsii9rr4qk9w7x8q2b2";
    }
  ];

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

  #browserpass
  programs.browserpass.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vscode
    vscode-with-extensions

    #zerotierone

    # Non free, need allowUnfree set to true
    zoom-us
    unrar
    skype
    teams

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
    gnomeExtensions.system-monitor
    gnome3.evolution
    gnome3.gnome-tweaks
    gnome3.vinagre
    evolution-data-server
    kazam
    
    # KDE stuff
    kdeApplications.spectacle

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
    citrix_workspace
    google-cloud-sdk
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
    aegisub
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
  ];

  networking.extraHosts =
  ''
    10.161.1.235 Canonceecf2.local
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
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 8096 22 32100 32001 ];
  networking.firewall.allowedUDPPorts = [ 8080 8096 22 32100 32001 ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

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
  system.stateVersion = "20.09"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  users.extraGroups.vboxusers.members = [ "velho" ];
  # Enable two lines below plus the virtualbox package to get vbox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;

  #services.zerotierone = {
  #  enable = true;
  #  joinNetworks = ["a13d7a0e59ae6de4"];
  #};
}

