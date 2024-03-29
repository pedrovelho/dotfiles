# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, ... }:
{
  # Options for Lenovo ThinkPad X1 Gen 3
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ./kill-all-docker-containers.nix
  ];

  # Enable graphical login and desktop
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "intl";
      xkbOptions = "eurosign:e";
      # NVIDIA Optimusprime
      videoDrivers = [ "nvidia" ];
      # NVIDIA Bumblebee
      #videoDrivers = [ "nvidia" ];
      #deviceSection = ''BusID "PCI:0:2:0"'';
      enableCtrlAltBackspace = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };
  };

  boot = {
    initrd.availableKernelModules = [ "battery" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    # extraModprobeConfig = ''
    #   options snd-intel-dspcfg dsp_driver=1
    # '';
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 1;
  };

  services.fstrim.enable = lib.mkDefault true;

  services.throttled.enable = lib.mkDefault true;
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  services.tlp.enable = false;

  # Accept non free packages, needed for skype, zoom, unrar, etc...
  nixpkgs.config.allowUnfree = true;

  # Disable explicitely use networkManager instead
  networking.useDHCP = false;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # browserpass
  programs.browserpass.enable = true;
  nixpkgs.config.firefox.enableBrowserpass = true;
  nixpkgs.config.firefox.enableGnomeExtensions = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Dev
    jetbrains.pycharm-community
    glib.dev
    linuxHeaders
    nodejs
    nodePackages.prettier
    nodePackages.eslint
    telepresence2

    # Non free, need allowUnfree set to true
    zoom-us
    unrar
    skypeforlinux

    # Nix utils
    nix-prefetch-scripts
    nix-zsh-completions

    # Monitoring
    psmisc
    pmutils
    nmap
    htop
    gtop
    usbutils
    iotop
    stress
    tcpdump
    lsof
    pciutils

    # Files
    meld
    file
    tree
    ncdu
    unzip
    zip
    p7zip
    unrar

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
    poppler_utils
    mediainfo # audio and video
    lingot    # guitar tuner
    pciutils

    # Gnome stuff
    gnome.gnome-disk-utility
    gnome.gnome-shell
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
    audio-recorder
    gnomeExtensions.gsconnect
    gettext
    libgtop
    gir-rs
    rake
    kazam

    # Web
    google-chrome
    chrome-gnome-shell
    firefox
    youtube-dl
    thunderbird
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

    # Security
    sssd

    # Utils
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
    xorg.xkill
    gcolor3
    graphviz
    imagemagick
    inkscape
    libreoffice
    gimp
    gitAndTools.gitFull
    python3
    python310Packages.virtualenv
    python310Packages.pyspark
    python310Packages.numpy
    python310Packages.pandas
    python310Packages.poetry
    spark
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
    azure-cli

    # Bluetooth
    bluez

    # Games
    chiaki
    retroarchFull
    playonlinux
    dolphin-emu

    # Others
    glxinfo
    gparted
    skopeo

    # PDF
    xournal
    xournalpp

    # Security
    openssl

    # Gtk
    transmission-gtk

    # Day to day use in Ryax
    cachix
    kubernetes-helm
    popeye
    kubectx
    helmfile
    kubectl
    kubelogin
    k9s
    pssh

    # Emulation
    lutris

    # Editors
    emacs
    emacsPackages.nix-mode
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
    qrencode

    # Printers
    gutenprint
    gutenprintBin
    sane-backends

    # kindle
    #koreader

    # DB
    dbeaver
    mariadb-client
    postgresql

    # Fun
    fortune
    sl
    wesnoth-dev
    docker-compose
    docker-machine
    sshfs-fuse
    skopeo

    # command line nouveau
    lsd
    silver-searcher
    ack
    mosh
    bat
    delta
    fd
    drill
    dog
    duf
    du-dust
    btop
    glances
    zenith
    tldr
    sd
    difftastic
    mtr
    plocate
    fasd
    autojump
    zoxide
    broot
    direnv
    fzf
    peco
    croc
    hyperfine
    httpie
    curlie
    xh
    entr
    asdf
    tig
    lazygit
    lazydocker
    choose
    ctop
    jc
    yq
    fx
    jless
    xsv
    visidata
    pdfgrep
    gron
    ripgrep-all
    thefuck

    # install ifuse
    ideviceinstaller
    ifuse
    libimobiledevice
  ];

  # Also install dev versions
  environment.extraOutputsToInstall = [ "dev" ];

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
    extraOptions = "--insecure-registry ryax-registry.ryaxns:5000";
    enableNvidia = true;
  };

  # Avoid journald to store GigaBytes of logs
  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';

  # Needed by ideviceX
  services.usbmuxd.enable = true;

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-nixos";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  users.extraGroups.vboxusers.members = [ "velho" ];

  services.avahi = {
    enable = true;
  };

  programs.steam.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # NVIDIA
  hardware.opengl.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  services.fprintd.enable = true;
}
