
{ pkgs ? import <nixpkgs>{}
, lib ? pkgs.lib 
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

  # shamilton = import (builtins.fetchTarball {
  #   url = "https://github.com/SCOTT-HAMILTON/nur-packages-template/archive/master.tar.gz";
  #   sha256 = "0a7lcizi9sw6jfpdqzjy1fgl50jipjcyglw1s0fad82p43yjwjwg" ;
  # }) {pkgs = pkgs;};
in rec
{
  imports = [
#    nur-no-pkgs.repos.shamilton.modules.home-manager.day-night-plasma-wallpapers 
    # shamilton.modules.home-manager.day-night-plasma-wallpapers 
    # ./../../GIT/nur-packages-template/modules/day-night-plasma-wallpapers-home-manager.nix
    ./modules/myvim
    ./modules/redshift-auto
  ];

  home.homeDirectory = "/home/scott";

  xdg = {
    enable = true;
    cacheHome = "${home.homeDirectory}/.local/cache";
    configHome = "${home.homeDirectory}/.config";
    dataHome = "${home.homeDirectory}/.local/share";
    mime.enable = true;
    mimeApps.enable = true;
  };

  home.packages = [
    ## Personnal apps
#    nur.repos.shamilton.day-night-plasma-wallpapers 

    ## Desktop Environment
    baobab
    gnome3.dconf
    kdeApplications.spectacle
    mpv
    simplescreenrecorder

    ## Development
    cmake 
    gnumake
    dfeet 
    gcc

    ## Games
    minecraft

    ## Graphics
    gimp

    ## Internet
    protonvpn-cli
    skype

    ## Packages managers
    flatpak

    ## Utilities
    doas
    nix-index
    patchelf
    xdotool
  ];


  myvim.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  programs.git = {
    enable = true;
    userName  = "SCOTT-HAMILTON";
    userEmail = "sgn.hamilton@protonmail.com";
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
}
