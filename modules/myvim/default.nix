{ config, lib, pkgs, options,
home, modulesPath
}:

with lib;

let
  cfg = config.myvim;
  MyVimConfig = pkgs.callPackage (import ./../../pkgs/MyVimConfig )
  { lib = lib; };
  MyVimFtplugins = pkgs.callPackage (import ./../../pkgs/vim-myftplugins )
  { lib = lib; };
in {

  options.myvim = {
    enable = mkEnableOption "My vim config from https://github.com/SCOTT-HAMILTON/vimconfig";
  };
  config = mkIf cfg.enable (mkMerge ([
    {
      programs.vim.enable = true;
      programs.vim.extraConfig = builtins.readFile "${MyVimConfig}/vimrc";
      programs.vim.plugins = [ 
        MyVimFtplugins
        "commentary"
        "vim-colorschemes"
        "vim-qml"
      ];
    }
  ]));
}
