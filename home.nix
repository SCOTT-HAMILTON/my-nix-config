 
{ pkgs ? import <nixpkgs>{}
, ... }:

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
in
{
  imports = [
#    nur-no-pkgs.repos.shamilton.modules.home-manager.day-night-plasma-wallpapers 
    # shamilton.modules.home-manager.day-night-plasma-wallpapers 
    # ./../../GIT/nur-packages-template/modules/day-night-plasma-wallpapers-home-manager.nix
    ./modules/myvim
    ./modules/redshift-auto
  ];
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
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

  # Inline modules
  ## Generates the shop file
  


#  services.day-night-plasma-wallpapers.enable = true;
#  services.day-night-plasma-wallpapers.onCalendar = "*-*-* 16:00:00";
  services.redshift-auto.enable = true;
  services.redshift-auto.onCalendar = "*-*-* 16:00:00";

  myvim.enable = true;

  programs.git = {
    enable = true;
    userName  = "SCOTT-HAMILTON";
    userEmail = "sgn.hamilton@protonmail.com";
  };
}
