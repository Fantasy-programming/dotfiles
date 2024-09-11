{  pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dogma";
  home.homeDirectory = "/home/dogma";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
      pkgs.tmux
    # pkgs.httpie

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/zsh" = { source = programs/zsh; recursive = true; };
    ".config/tmux" = {source = programs/tmux; recursive = true; };
  };

  # Programs

  programs.git = {
    enable = true;
    userName = "Fantasy Programming";
    userEmail = "freedominwork@fullmetal.anonaddy.com";
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        # theme = {
        #   activeBorderColor = ["blue" "bold"];
        #   inactiveBorderColor = ["white"];
        #   optionsTextColor = ["blue"];
        #   selectedLineBgColor = ["default"];
        #   selectedRangeBgColor = ["default"];
        #   cherryPickedCommitBgColor = ["cyan"];
        #   cherryPickedCommitFgColor = ["blue"];
        #   unstagedChangesColor = ["red"];
        #   };
        showFileTree = true;
        showListFooter = false;
        showRandomTip = false;
        showBottomLine = false;
        showCommandLog = true;
        showIcons = false;
      };
      disableStartupPopups = true;
      notARepository = "skip";
      os.editCommand = "nvim";
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
#     settings = {
#       command_timeout = 10000;
#       add_newline = true;
#       line_break.disabled = true;
#       character = {
#         error_symbol = " [✖](bold red) ";
#       };
#       hostname = {
#         ssh_only = true;
#         format = "<[$hostname]($style)>";
#         trim_at = "-";
#         style = "bold dimmed white";
#         disabled = false;
#       };
#       cmd_duration = {
#         min_time = 1;
#         format = " took [$duration]($style)";
#         style = "bold italic red";
#         disabled = false;
#       };
#       directory = {
#         truncation_length = 3;
#         truncation_symbol = "…/";
#         format = "[$path]($style)[$lock_symbol]($lock_style) ";
#       };
#       git_branch = {
#         format = " [$symbol$branch]($style) ";
#         symbol = "🍣 ";
#         style = "bold yellow";
#       };
#       git_status = {
#         conflicted = "=";
#         ahead =	"⇡\${count} ";
#         behind = "⇣\${count} ";
#         diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
#         up_to_date = " ";
#         untracked = "?\${count} ";
#         stashed = " ";
#         modified = "!\${count} ";
#         staged = "+\${count} ";
#         renamed = "»\${count} ";
#         deleted = "🗑️ ×\${count} ";
#         style = "bright-white";
#         format = "$all_status$ahead_behind";
#       };
#       git_commit = {
#         commit_hash_length = 8;
#         style = "bold white";
#       };
#       git_state = {
#         rebase = "REBASING";
#         merge =	"MERGING";
#         revert = "REVERTING";
#         cherry_pick = "CHERRY-PICKING";
#         bisect = "BISECTING";
#         am = "AM";
#         am_or_rebase = "AM/REBASE";
#         style =	"yellow";
#         format = "\([$state( $progress_current/$progress_total)]($style)\) ";
#       };
#       julia = {
#         format = "[$symbol$version]($style) ";
#         symbol = "ஃ ";
#         style = "bold green";
#       };
#       python = {
#         format = "[$symbol$version]($style) ";
#         style = "bold green";
#       };
#       username = {
#         format = "[$symbol$version]($style) ";
#         style = "bold green";
#       };
#       nodejs = {
#         format = "via [🤖 $version](bold green) ";
#         detect_files = ["package.json" ".node-version"];
#         detect_folders = ["node_modules"];
#       };
#       aws.symbol = " ";
#       conda.symbol = " ";
#       elixir.symbol = " ";
#       elm.symbol = " ";
#       docker_context = {
#         symbol = " ";
#         format = "via [$symbol$context]($style) ";
#         style = "blue bold";
#         only_with_files = true;
#         detect_files = ["docker-compose.yml" "docker-compose.yaml" "Dockerfile"];
#         detect_folders = [];
#         disabled = false;
#       };
#       format = "
# $username\
# $hostname\
# $shlvl\
# $singularity\
# $kubernetes\
# $directory\
# $vcsh\
# $git_branch\
# $git_commit\
# $git_state\
# $git_metrics\ 
# $git_status\
# $hg_branch\
# $docker_context\
# $package\
# $cmake\
# $cobol\
# $dart\ 
# $deno\
# $dotnet\
# $elixir\
# $elm\
# $erlang\
# $golang\
# $helm\
# $java\
# $julia\
# $kotlin\ 
# $lua\
# $nim\
# $nodejs\
# $ocaml\
# $perl\
# $php\
# $pulumi\
# $purescript\
# $python\ 
# $rlang\
# $red\
# $ruby\
# $rust\
# $scala\ 
# $swift\
# $terraform\
# $vlang\
# $vagrant\
# $zig\ 
# $nix_shell\
# $conda\
# $memory_usage\
# $aws\
# $gcloud\
# $openstack\
# $azure\
# $env_var\ 
# $crystal\
# $custom\
# $sudo\
# $cmd_duration\
# $line_break\
# $jobs\
# $time\ 
# $status\
# $shell\
# [$character](bold green)
# ";
    # };
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dogma/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
