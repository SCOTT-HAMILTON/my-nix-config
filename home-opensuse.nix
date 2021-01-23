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
    rev = "249650a07ee2d949fa599f3177a8c234adbd1bee"; # CHANGEME 
    ref = "latest";
  };
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
  {};
  localShamilton = import ./../../GIT/nur-packages-template/default.nix {};
  shamilton = import (builtins.fetchTarball {
    url = "https://github.com/SCOTT-HAMILTON/nur-packages-template/archive/master.tar.gz";
    sha256 = "1iiqcczrd79pihwpib3c3vmq0n7cg9if91rqxkq442lwpzvs41pp";
  }) {pkgs = pkgs;};
in
rec
{
  imports = [
   localShamilton.modules.hmModules.myvim
   localShamilton.modules.hmModules.pronotebot
   localShamilton.modules.hmModules.sync-database
   nur-no-pkgs.repos.shamilton.modules.hmModules.redshift-auto
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
   localShamilton.keysmith
   localShamilton.merge-keepass
   localShamilton.pronotebot
   localShamilton.scripts
   localShamilton.xtreme-download-manager
 ];

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
