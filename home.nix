{ pkgs ? import <nixpkgs>{} 
, lib ? pkgs.lib
, config
, options
, modulesPath
, specialArgs
}:
with pkgs;
let
  localShamilton = import ./../../GIT/nur-packages/default.nix {
    localUsage = true;
  };
  nixpkgs-discord = import (builtins.fetchTarball {
    url = "http://github.com/NixOS/nixpkgs/archive/501e54080dfc82c41011d371677a7390eab61586.tar.gz";
    sha256 = "06l2wb0mi0dqvjawik9j8ncdgxzi6cqsm0fv0fph2m18p5bryxy9";
  }) {};
  nixpkgs-googleearthpro = import (builtins.fetchTarball {
    url = "http://github.com/SCOTT-HAMILTON/nixpkgs/archive/83c4ed8121e9e29cbe86faf09c426ddf8db9a9e5.tar.gz";
    sha256 = "1v03i28144rcmlf6jnjg0025snvhiwpd62b2hwjw4sp2hsa06l17";
  }) {};
  nixpkgs-inkscape = import (builtins.fetchTarball {
    url = "http://github.com/SCOTT-HAMILTON/nixpkgs/tarball/297d1d6";
    sha256 = "0vim9j8ab5wq0fgns4bs877zhpqaa2d08nvlvmb7s5mxnw4mfqz8";
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
    localShamilton.overlays.tabbed
    localShamilton.overlays.alacritty
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
    localShamilton.autognirehtet
    localShamilton.cdc-cognitoform-result-generator
    localShamilton.controls-for-fake
    localShamilton.fake-mic-wav-player
    localShamilton.haste-client
    localShamilton.json-beautifier
    localShamilton.juk
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
    localShamilton.splat
    localShamilton.timetable2header
    localShamilton.xtreme-download-manager
    localShamilton.yaml2probatree

    ## Audio
    audaciousQt5

    ## Desktop Environment
    gnome3.dconf
    libreoffice-fresh
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

    ## Documentation
    man-pages
    posix_man_pages

    ## Games
    bomber
    libsForQt5.kdeApplications.kbreakout
    libsForQt5.kdeApplications.kgeography
    minecraft
    superTuxKart

    ## Graphics
    blender
    gimp
    nixpkgs-inkscape.inkscape

    ## Internet
    tdesktop
    nheko
    nixpkgs-discord.discord
    protonvpn-cli
    skype

    ## Packages managers
    flatpak

    ## Utilities
    adb-sync
    alacritty
    baobab
    doas
    gnirehtet
    gnome3.adwaita-icon-theme
    kapptemplate
    nix-index
    nixpkgs-googleearthpro.googleearth-pro
    nixpkgs-review
    openjdk
    patchelf
    python3Packages.youtube-dl
    ripgrep
    rofi
    tabbed
    texlive.combined.scheme-full
    tldr
    tree
    xnee
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
