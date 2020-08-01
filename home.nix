{ pkgs ? import <nixpkgs>{} , lib ? pkgs.lib 
, config
, options
, modulesPath
}:

with builtins;
with lib;
with pkgs;

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
    ref = "release-18.09";
  };
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
  {};

  localShamilton = import ./../../GIT/nur-packages-template/default.nix {};

  shamilton = import (builtins.fetchTarball {
    url = "https://github.com/SCOTT-HAMILTON/nur-packages-template/archive/master.tar.gz";
    sha256 = "1iiqcczrd79pihwpib3c3vmq0n7cg9if91rqxkq442lwpzvs41pp";
  }) {pkgs = pkgs;};

  lupdate = callPackage ./pkgs/lupdate { };
  lrelease = callPackage ./pkgs/lrelease { };
in rec
{
  imports = [
    # nur-no-pkgs.repos.shamilton.modules.home-manager.day-night-plasma-wallpapers
    # shamilton.modules.home-manager.day-night-plasma-wallpapers 
    # ./../../GIT/nur-packages-template/modules/day-night-plasma-wallpapers-home-manager.nix
    localShamilton.modules.hmModules.myvim
    nur-no-pkgs.repos.shamilton.modules.hmModules.redshift-auto
    nur-no-pkgs.repos.shamilton.modules.hmModules.sync-database
    ./../passwords
    ./../user
  ];

  nixpkgs.overlays = [ ];

  home.homeDirectory = config.home-dir.home_dir;

  xdg = {
    enable = true;
    cacheHome = "${home.homeDirectory}/.local/cache";
    configHome = "${home.homeDirectory}/.config";
    dataHome = "${home.homeDirectory}/.local/share";
    mime.enable = true;
    mimeApps.enable = true;
  };

  myvim.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  home.packages = [
    ## Personnal apps
    nur.repos.shamilton.baobab
    nur.repos.shamilton.bomber
    localShamilton.controls-for-fake
    nur.repos.shamilton.fake-mic-wav-player
    localShamilton.gufw
    nur.repos.shamilton.inkscape
    nur.repos.shamilton.juk
    nur.repos.shamilton.kapptemplate
    nur.repos.shamilton.kbreakout
    nur.repos.shamilton.keysmith
    nur.repos.shamilton.killbots
    nur.repos.shamilton.kirigami-gallery
    nur.repos.shamilton.ksmoothdock
    nur.repos.shamilton.lokalize
    nur.repos.shamilton.merge-keepass
    nur.repos.shamilton.scripts
    nur.repos.shamilton.spectacle-clipboard
    nur.repos.shamilton.super-tux-kart
    nur.repos.shamilton.wiiuse

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
    # gcc
    # gnome3.glade
    # qt5.full
    clang_10
    cmake 
    cntr
    dfeet 
    docker
    docker-compose
    fira-code
    gdb
    gettext
    gnumake
    lrelease
    lupdate
    meson
    poedit
    qt5.qtdoc
    qt5.qttools
    qtcreator

    ## Games
    minecraft
    dosbox
    kdeApplications.kgeography

    ## Graphics
    blender
    gimp

    ## Internet
    protonvpn-cli
    skype

    ## Packages managers
    flatpak

    ## Utilities
    adb-sync
    doas
    filelight
    gnome3.adwaita-icon-theme
    nix-index
    patchelf
    python3Packages.youtube-dl
    texlive.combined.scheme-full
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

  # programs.texlive = {
  #   enable = true;
  # };

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
      alias ytdl="cd ~/Musique;youtube-dl -x --audio-format opus -o \"%(title)s.mkv\""
      export XDG_CACHE_HOME="${home.homeDirectory}/.local/cache"
      export XDG_CONFIG_HOME="${home.homeDirectory}/.config"
      export XDG_DATA_HOME="${home.homeDirectory}/.local/share"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    plugins = [
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
      };
    }];
  };

  services.redshift-auto.enable = true;
  services.redshift-auto.onCalendar = "*-*-* 16:00:00";

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
