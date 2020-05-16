# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let 
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vim.nix
      ./cachix.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdc"; # or "nodev" for efi only
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;   #latest;
  boot.kernelParams = [ "intel_iommu=on" "pcie_aspm=off"];

  boot.extraModprobeConfig = "options kvm_intel nested=1";

  boot.resumeDevice = "/dev/md126";

  boot.blacklistedKernelModules = ["nouveau"];

  nix.maxJobs = 6;
  nix.buildCores = 6;

  fileSystems."/var" =
    { device = "/dev/disk/by-label/nixosvar";
    };
  fileSystems."/home" = 
    { device = "/dev/disk/by-label/nixoshome";
      options = [ "noatime" ];
    };
  #fileSystems."/oldhome" =
  #  { device = "/dev/sde3";
  #  };
  fileSystems."/data" =
    { device = "/dev/disk/by-label/data";
      options = [ "nofail" ];
    };
  fileSystems."/games" =
    { device = "/dev/disk/by-label/games2";
      options = [ "nofail" ];
    };

  swapDevices = [
    {
      device = "/dev/md126p1";
      priority = 100;
      size = null;
    }
  ];

  time.timeZone = "America/Chicago"; 

  networking.hostName = "golgatha"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp11s0.useDHCP = true;
  networking.interfaces.enp12s0.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlxfc75168bae5e.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let 
      browsers = [ unstable.firefox firefox-devedition-bin midori w3m google-chrome vivaldi vivaldi-ffmpeg-codecs luakit googleearth falkon opera ];
      editors = [ vim neovim gnumeric emacs libreoffice blackbird ];
      terminal = [ zsh fish tmux guake terminator xclip jq tilda enlightenment.terminology kitty alacritty tilix cool-retro-term busybox taskell ];
      games = [ steam steam-run playonlinux minetest  gnome3.gnome-sudoku dolphin dolphinEmu wine openmw openmw-tes3mp unstable.minecraft ];
      # games = [ steam steam-run playonlinux minecraft minetest minecraft-server gnome3.gnome-sudoku dolphin dolphinEmu ];
      diskTools = [ gparted baobab lsof mc inotify-tools p7zip libmtp jmtpfs ];
      textTools = [ qpdfview unoconv calibre okular pdftk ];
      edgeComputing = [ boinc ngrok cgminer deluge ];
      art = [ alchemy blender ];
      music = [ clementine spotify mopidy airsonic alsaUtils ];
      deviceManagement = [ pavucontrol blueman xboxdrv openshot-qt obs-studio gnome3.cheese qjoypad bluedevil gnome3.gnome-bluetooth sdl-jstest gnome3.gnome-power-manager gphoto2 alsaTools alsaUtils xorg.xmodmap androidenv.androidPkgs_9_0.platform-tools arandr ];
      backup = [ rclone git aria2 syncthing drive ];
      monitoring = [ htop lm_sensors psensor weather nethogs smem iotop ];
      other = [ unzip lxappearance python pythonPackages.dbus-python singularity ];
      archive = [ unrar unzip ];
      webtools = [ wget thttpd mutt msmtp mailutils ssmtp ];
      haskell = [ haskellPackages.ghc haskellPackages.stack ];
      math = [ wxmaxima gap sagemath  singular yacas giac ];
      communication = [ discord zoom-us jitsi riot-desktop wire-desktop signal-desktop xournal gnome3.geary thunderbird kontact kmail claws-mail sylpheed ];
      learning = [ anki ];
      # videoImages = [ vlc gimp krita gphoto2 obs-studio ffmpeg shutter linuxPackages.nvidia_x11 arandr gthumb imagemagick];
      images = [ gimp krita gphoto2 gthumb imagemagick inkscape gfxtablet ];
      video = [ vlc obs-studio ffmpeg shutter ]; #linuxPackages.nvidia_x11 ];
      programming = haskell ++ [ openjdk android-studio unity3d ]; #cudatoolkit ];
      libraries = [ libuuid ];
      virtualization = [ virtmanager-qt virtmanager libguestfs jre8Plugin ];
    in
      browsers
      ++ art
      ++ editors
      ++ terminal
      ++ archive
      ++ games
      ++ diskTools
      ++ textTools
      ++ virtualization
      ++ edgeComputing
      ++ libraries
      ++ music
      ++ video
      ++ images 
      ++ learning
      ++ communication
      ++ deviceManagement
      ++ monitoring
      ++ haskell
      ++ backup
      ++ other
      ++ webtools
      ++ programming
      ++ math;

  services.flatpak.enable = true;

  fonts.fonts = with pkgs; [
    dina-font
  ];
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  programs.tmux.keyMode="vi";

  virtualisation.libvirtd = {
    enable = true;
    qemuVerbatimConfig = ''
	    namespaces = []

# Whether libvirt should dynamically change file ownership
	    dynamic_ownership = 0
	    '';
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh

  services.openssh = {
    enable = true;
    forwardX11 = true;
    listenAddresses = [ { addr = "0.0.0.0"; port = 22; } { addr = "0.0.0.0"; port = 22222; } ];
  };

  # services.postfix.enable = true;

  programs.mosh.enable = true;

  services.ddclient = {
    enable = true;
    protocol = "noip";
    # web = "";
    username = "darclaw.z@gmail.com";
    password = (import /home/darclaw/secrets.nix).noipPass;
    server = "dynupdate.no-ip.com";
    domains = ["golgatha.ddns.net"];
  };

  #services.ssmtp = {
  #  enable = true;
  #  hostName = "smtp.zoho.com";
  #  authuser = "davidcrosby@zoho.com";
  #  authPass = (import /home/darclaw/secrets.nix).zohoSMTPPass;
  #};


  networking.firewall.enable = false;
  #networking.bridges.br0.interfaces = [ "enp12s0" "enp7s0" ];
  #networking.vswitches = { vs0.interfaces = [ "enp12s0" "enp7s0" "enp6s0" "enp11s0" ]; };
  
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "enp12s0";
  # networking.nat.internalIPs = [ "192.168.1.0/24" "192.168.2.0/24" "192.168.3.0/24" ];
  # networking.interfaces.enp7s0.ipAddress = "192.168.1.1";
  # networking.interfaces.enp7s0.prefixLength = 24;
  # networking.interfaces.enp6s0.ipAddress = "192.168.2.1";
  # networking.interfaces.enp6s0.prefixLength = 24;
  # networking.interfaces.enp11s0.ipAddress = "192.168.3.1";
  # networking.interfaces.enp11s0.prefixLength = 24;

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    user = "darclaw";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  services.redshift = {
    enable = true;
    #extraOptions = ["-l 36.085717:-94.209584"];
    #provider = "geoclue2";
  };

  location.provider = "geoclue2";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver = {
    enable = true;
    layout = "us";
    #xkbVariant = "neo";
    windowManager.notion.enable = true;
    desktopManager.xfce.enable = true;
    desktopManager.gnome3.enable = true;
    desktopManager.enlightenment.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  # windowManager.default = "xmonad";
  # services.xserver.videoDrivers = [ "nvidia" ];
  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ gnome3.dconf gnome2.GConf ];
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;

  services.upower.enable = true;

  #systemd.user.services.syncthing = {
  #  enable = true;
  #  #description = "starts syncthing on boot";
  #  #script = "/home/darclaw/startSyncthing.sh";
  #  #after = [ "network.target" ];
  #};
   
 
  virtualisation.docker.enable = true;

  systemd.services.startSyncthing = {
      wantedBy = [ "multi-user.target" ]; 
      after = [ "network.target" ];
      description = "Start Syncthig as darclaw.";
      serviceConfig = {
        Type = "oneshot";
        User = "darclaw";
        ExecStart = ''${pkgs.syncthing}/bin/syncthing''; #''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';         
        #ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
   };

  systemd.services.startNgrokSSH = {
      wantedBy = [ "multi-user.target" ]; 
      after = [ "network.target" ];
      description = "Start Ngrok ssh as darclaw.";
      serviceConfig = {
        Type = "oneshot";
        User = "darclaw";
        ExecStart = ''${pkgs.ngrok}/bin/ngrok start ssh''; #''${pkgs.screen}/bin/screen -dmS irc ${pkgs.irssi}/bin/irssi'';         
        #ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
      };
  };
  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.extraUsers.darclaw = {
    name = "darclaw";
    group = "users";
    extraGroups = [
      "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "docker" "lxd" "libvirtd"  "vboxusers"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/darclaw";
    shell = "/run/current-system/sw/bin/bash";
    #shell = pkgs.fish;
  };

  users.extraUsers.drannex = {
    name = "drannex";
    group = "users";
    extraGroups = [
      "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "docker" "lxd" "libvirtd" 
    ];
    createHome = true;
    uid = 1004;
    home = "/home/drannex";
    shell = "/run/current-system/sw/bin/bash";
    #shell = pkgs.fish;
  };

  users.extraUsers.dhader = {
    name = "dhader";
    group = "users";
    extraGroups = [
      "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "docker" "lxd" "libvirtd" 
    ];
    createHome = true;
    uid = 1005;
    home = "/home/dhader";
    shell = "/run/current-system/sw/bin/bash";
    #shell = pkgs.fish;
  };
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

