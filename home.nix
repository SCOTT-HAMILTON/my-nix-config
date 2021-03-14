{ pkgs ? import <nixpkgs>{} 
, lib ? pkgs.lib
, config
, options
, modulesPath
}:
with pkgs;
let
  localShamilton = import ./../../GIT/nur-packages-template/default.nix {
    localUsage = true;
  };
  nixpkgs-discord = import (builtins.fetchTarball {
    url = "http://github.com/NixOS/nixpkgs/archive/247e919436b2423012c7aade2189d8e5fc3c2a5e.tar.gz";
    sha256 = "1j07jc8y1gfwdw1c084kks70ddgimczfjghc3w7zcw6wh73si5jx";
  }) {};
  # shamilton = import (builtins.fetchTarball {
  #   url = "https://github.com/SCOTT-HAMILTON/nur-packages-template/archive/master.tar.gz";
  #   sha256 = "1iiqcczrd79pihwpib3c3vmq0n7cg9if91rqxkq442lwpzvs41pp";
  # }) {pkgs = pkgs;};
  # lupdate = callPackage ./pkgs/lupdate { };
  # lrelease = callPackage ./pkgs/lrelease { };
in
rec
{
  imports = [
    localShamilton.modules.hmModules.myvim
    localShamilton.modules.hmModules.pronotebot
    localShamilton.modules.hmModules.pronote-timetable-fetch
    localShamilton.modules.hmModules.sync-database
    localShamilton.modules.hmModules.redshift-auto
    ./../passwords
    ./../user
  ];
  myvim.enable = true;
  services.redshift-auto.enable = true;
  services.redshift-auto.onCalendar = "*-*-* 16:00:00";
  home.homeDirectory = config.home-dir.home_dir;
  nixpkgs.overlays = [
    localShamilton.overlays.rofi
    localShamilton.overlays.alacritty
    localShamilton.overlays.tabbed
  ];
  xdg = {
    enable = true;
    cacheHome = "${home.homeDirectory}/.local/cache";
    configHome = "${home.homeDirectory}/.config";
    dataHome = "${home.homeDirectory}/.local/share";
    mime.enable = true;
    mimeApps.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  home.packages = [
    ## Personnal apps
    localShamilton.android-platform-tools
    localShamilton.baobab
    localShamilton.bomber
    localShamilton.cdc-cognitoform-result-generator
    localShamilton.controls-for-fake
    localShamilton.fake-mic-wav-player
    localShamilton.haste-client
    localShamilton.juk
    localShamilton.kapptemplate
    localShamilton.kbreakout
    localShamilton.keysmith
    localShamilton.killbots
    localShamilton.kirigami-gallery
    localShamilton.lokalize
    localShamilton.merge-keepass
    localShamilton.pdf2timetable
    localShamilton.pronote-timetable-fetch
    localShamilton.pronotebot
    localShamilton.scripts
    localShamilton.spectacle-clipboard
    localShamilton.super-tux-kart
    localShamilton.timetable2header
    localShamilton.unoconvui
    localShamilton.xtreme-download-manager
    localShamilton.yaml2probatree

    ## Audio
    audaciousQt5

    ## Desktop Environment
    gnome3.dconf
    libreoffice    
    mpv
    simplescreenrecorder
    mate.eom
    zathura

    ## Development
    clang_10
    cmake 
    cntr
    dfeet 
    docker
    docker-compose
    fira-code
    gdb
    ninja
    meson
    qtcreator

    ## Games
    minecraft
    kdeApplications.kgeography

    ## Graphics
    blender
    gimp
    inkscape

    ## Internet
    protonvpn-cli
    skype
    nixpkgs-discord.discord

    ## Packages managers
    flatpak

    ## Utilities
    adb-sync
    alacritty
    doas
    gnome3.adwaita-icon-theme
    gource
    nix-index
    nixpkgs-review
    patchelf
    python3Packages.youtube-dl
    ripgrep
    rofi
    texlive.combined.scheme-full
    tabbed
    tldr
    tree
    xdotool
  ];

  programs.emacs = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName  = "SCOTT-HAMILTON";
    userEmail = "sgn.hamilton+github@protonmail.com";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    history = {
      extended = true;
      ignoreDups = true;
      path = "${xdg.dataHome}/zsh/zsh_history";
    };
    initExtra = ''
      export XDG_CACHE_HOME="${home.homeDirectory}/.local/cache"
      export XDG_CONFIG_HOME="${home.homeDirectory}/.config"
      export XDG_DATA_HOME="${home.homeDirectory}/.local/share"
    '';
    shellAliases = {
      ytdl = "cd ~/Musique;./youtube-dl -x --audio-format opus -o \"%(title)s.mkv\"";
      alacritty = "tabbed -cr 2 alacritty --embed ''"; 
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    plugins = [
      # {
      #   name = "zsh-syntax-highlighting";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "zsh-users";
      #     repo = "zsh-syntax-highlighting";
      #     rev = "0.7.1";
      #     sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
      #   };
      # }
    ];
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "scott-NEAL-PC" = {
        hostname = "NEAL-PC";
        user = "scott";
        port = 817;
      };
    };
  };

  manual.manpages.enable = false;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
