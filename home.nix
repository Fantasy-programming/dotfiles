{  pkgs, ... }:

{
  # Info about the path home manager needs.
  home.username = "dogma";
  home.homeDirectory = "/home/dogma";

  # Don't change this (ever) unless the release notes allows you
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Packages
  home.packages = [
      pkgs.neovim
      pkgs.gh
      pkgs.zig
      pkgs.unzip
      pkgs.gcc
      pkgs.cargo
      pkgs.devenv
      pkgs.fzf
      pkgs.eza
      pkgs.fd
      pkgs.ripgrep
      pkgs.yazi
      pkgs.tmux
      pkgs.gnupg
      pkgs.ollama
      pkgs.btop
      pkgs.goldwarden
      pkgs.tmux-sessionizer
      pkgs.jq
      pkgs.lazydocker
      pkgs.glow
  ];

  # Dotfiles (manual)
  home.file = {
    ".config/zsh" =  { source = programs/zsh; recursive = true; };
    ".config/tmux" = {source = programs/tmux; recursive = true; };
  };


  # Programs (managed)
  programs.git = {
    enable = true;
    userName = "Fantasy Programming";
    userEmail = "freedominwork@fullmetal.anonaddy.com";
    signing.key = "ADA372E9F6C2C4E3";
    signing.signByDefault = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileTree = true;
        showListFooter = false;
        showRandomTip = false;
        showBottomLine = false;
        showCommandLog = true;
        showIcons = false;
      };
      disableStartupPopups = true;
      notARepository = "skip";
      os.edit = "nvim";
    };
  };


  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtraFirst = "
while read file
do
  source \"$ZDOTDIR/$file.zsh\"
done <<-EOF
theme
env
aliases
utility
options
plugins
keybinds
prompt
EOF
    ";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; 
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    TERM = "xterm-256color";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
