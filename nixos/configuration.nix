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
    exec "$@"
  '';
in
{

  # Options for Lenovo ThinkPad X1 Gen 3
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ./kill-all-docker-containers.nix
    ./cachix.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-sandbox-paths = /var/cache/ccache
    '';
  };


  # disable a bunch of gnome junk apps, gnome-calculator, gedit, etc...
  services.gnome.core-utilities.enable = false;
  # diable gnome-keyring use only gnupg agent
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  # Enable graphical login and desktop
  services = {
    xserver = {
      enable = true;
      # layout = "us";
      # xkbVariant = "intl";
      # xkbOptions = "eurosign:e";
      # NVIDIA Optimusprime
      videoDrivers = [ "nvidia" ];
      enableCtrlAltBackspace = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };
  };

  fonts.fontconfig = { enable = true; };
  # Add micro$oft fonts
  fonts.packages = with pkgs; [
    corefonts
    nerdfonts
  ];

  services.acpid.enable = true;

  boot = {
    initrd.availableKernelModules = [ "battery" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelParams = [ "psmouse.synaptics_intertouch=0" ];
    #extraModprobeConfig = ''
    #  options snd-intel-dspcfg dsp_driver=1
    #'';
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
  nixpkgs.config.cudaSupport = false;

  # Disable explicitely use networkManager instead
  networking.useDHCP = false;

  # Set your time zone.
  #time.timeZone = "Europe/Paris";

  # browserpass
  programs.browserpass.enable = true;
  programs.firefox.nativeMessagingHosts.browserpass = true;
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.browserpass pkgs.gnome-browser-connector ];
  # Needed for browserpass to call gnupg
  programs.gnupg.agent.enable = true;

  environment.variables = {
    GSK_RENDERER = "ngl";
  };

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
    nodePackages.create-react-app
    #telepresence2


    # Nice to have
    fastfetch

    # Non free, need allowUnfree set to true
    zoom-us
    unrar
    skypeforlinux

    # Nix utils
    nix-prefetch-scripts
    nix-zsh-completions
    nix-tree

    # gnome tools
    nautilus
    gnome-terminal

    # Wii backup
    wiimms-iso-tools

    # Monitoring
    psmisc
    pmutils
    nmap
    htop
    gtop
    usbutils
    libusb1
    zlib
    iotop
    stress
    tcpdump
    #wireshark
    lsof
    pciutils

    paraview
    #openfoam11

    # Files
    meld
    file
    tree
    ncdu
    unzip
    zip
    p7zip
    unrar

    # CUDA GPU NVIDIA
    # cudatoolkit
    # enable nvidia-offload script
    #nvidia-offload

    # Java
    maven
    yarn
    jdk

    # usb drives, disks, boot
    refind
    grub2
    gptfdisk

    # Password store
    pass

    # Command line extra
    bc
    mpg123
    ffmpeg
    hping
    iftop

    # Tools
    zsh
    tmux
    ranger
    ansible
    # ranger previews
    libcaca   # video
    jellyfin  # homemade netflix
    highlight # code
    atool     # archives
    w3m       # web
    poppler   # PDF
    evince
    poppler_utils
    mediainfo # audio and video
    alsa-utils
    lingot    # guitar tuner
    pciutils
    audacity

    # Gnome stuff
    audio-recorder
    gnomeExtensions.system-monitor-next
    gnomeExtensions.gsconnect
    gettext
    libgtop
    gir-rs
    rake
    kazam
    texlive.combined.scheme-full

    # Web
    google-chrome
    firefox
    browserpass
    gnome-browser-connector
    yt-dlp
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
    liferea

    # Media
    vlc

    # Security
    sssd

    # Utils
    git-cola
    bfg-repo-cleaner
    gitg
    git-lfs
    openapi-generator-cli

    # ssh
    dropbear

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

    # Python packages
    ( python3.withPackages(ps: with ps;
      [
        pyusb
      ]
    ))

    # Jupyter
    jupyter


    # Graphic tools
    xorg.xkill
    gcolor3
    graphviz
    imagemagick
    inkscape
    libreoffice
    gimp
    gitAndTools.gitFull
    go
    ruff
    poetry
    glances
    gcc
    valgrind
    clang
    ctags
    gnumake
    wget
    sbt-with-scala-native
    cmake
    gdb
    direnv
    entr
    pandoc
    socat

    # Cloud stuff
    awscli2
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    rclone
    azure-cli

    # Bluetooth
    bluez

    # Games
    #retroarchFull
    #wine64

    # Others
    glxinfo
    gparted
    skopeo

    # PDF
    xournalpp

    # Security
    openssl

    # Gtk
    transmission_4-gtk

    # Day to day use in Ryax
    cachix
    kubernetes-helm
    kind
    kubectx
    helmfile
    kubectl
    kubelogin

    # Editors
    emacs
    emacsPackages.nix-mode
    emacsPackages.ts
    emacsPackages.tree-sitter
    emacsPackages.tree-sitter-langs
    vim

    # Canon drivers
    canon-cups-ufr2

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

    # DB
    postgresql

    # Fun
    fortune
    sl
    wesnoth-dev
    sshfs-fuse

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

  networking.extraHosts =
  ''
    10.50.1.235 Canon.local Canonceecf2.local Canon_MF642C_643C_644C_de_ed_f5_de_ed_f5_de_ed_de_ed_f5
    127.0.0.1 myfakedomain.local
  '';

  programs.light.enable = true;

  programs.zsh.enable = true;

  # Enable docker on boot
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraOptions = "--insecure-registry ryax-registry.ryaxns:5000";
  };
  # enable gpu on docker
  hardware.nvidia-container-toolkit.enable = true;


  # Avoid journald to store GigaBytes of logs
  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';

  # Needed by ideviceX
  services.usbmuxd.enable = true;

  programs.ssh.forwardX11 = true;

  # Enable singularity
  programs.singularity.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Avoid nix-daemon to use more than 50% of memory
  # OOM configuration:
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };

  networking.hostName = "lenovo-nixos";

  # With flake we do things differently to upgrade:
  # 1) go to /etc/nixos/flake.nix
  # 2) edit file change the nixos-xx.yy version
  # 3) sudo nix flake update
  # 4) sudo nixos-rebuild --flake /etc/nixos/#lenovo-nixos switch --upgrade
  # 5) Optionally update firmwares:
  #    sudo fwupdmgr refresh ; sudo fwupdmgr get-updates
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  users.extraGroups.vboxusers.members = [ "velho" ];

  # List services that you want to enable:
  services.fprintd.enable = false;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.cnijfilter2 ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  system.nssModules = with pkgs.lib; optional (!config.services.avahi.nssmdns4) pkgs.nssmdns;
  system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns4) (mkMerge [
    (mkOrder 900 [ "mdns4_minimal [NOTFOUND=return]" ]) # must be before resolve
    (mkOrder 1501 [ "mdns4" ]) # 1501 to ensure it's after dns
  ]);

  # Enable steam client
  programs.steam.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # NVIDIA
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;

    prime = {
      offload.enable = true;
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # Sound
  nixpkgs.config.pulseaudio = false;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

}

