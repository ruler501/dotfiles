{ config, pkgs, nonicons, lib, ... }:
let
  pythonPackages = pkgs.python310Packages;
  nodePackages = pkgs.nodePackages;
  colors = import ./darkviolet.nix;
in
{
  home = {
    activation = {
      # patch-steam = lib.hm.dag.entryAfter["writeBoundary"] "
      #   mkdir -p ~/.local/share/applications
      #   sed 's/^Exec=/&nvidia-offload /' /run/current-system/sw/share/applications/steam.desktop > ~/.local/share/applications/steam.desktop
      # ";
      pnpm-global = lib.hm.dag.entryAfter["writeBoundary"] "
        mkdir -p /home/devon/.pnpm_global
      ";
    };
    file = {
      ".config/fonts/nonicons.ttf".source = "${nonicons.outPath}/dist/nonicons.ttf";
      ".zsh/plugins/plugins/poetry/_poetry".source = ../_poetry;
      ".pdbrc".source = ../pdbrc;
    };
    homeDirectory = "/home/devon";
    keyboard.options = [ "ctrl:nocaps" ];
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];
    stateVersion = "22.11";
    username = "devon";
  };
  programs = {
    command-not-found.enable = true;
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      config = {
        load_dotenv = false;
      };
      enable = true;
      nix-direnv = {
        enable = true;
      };
      enableZshIntegration = true;
    };
    firefox.profiles = {};
    git = {
      delta = {
        enable = true;
        options = {
          side-by-side = true;
        };
      };
      enable = true;
      extraConfig = {
        core = {
          eol = "lf";
        };
        color = {
          ui = true;
        };
        init = {
          defaultBranch = "dev";
        };
        merge = {
          tool = "vim_mergetool";
          conflictstyle = "diff3";
        };
        mergetool = {
          keepBackup = false;
        };
        "mergetool \"vim_mergetool\"" = {
          cmd = "nvr --remote-wait -c \"DiffviewOpen\"";
          trustExitCode = false;
        };
        pull = {
          rebase = true;
        };
      };
      includes = [
        {
          path = "~/.gnupg/.git-userconfig";
        }
      ];
      lfs.enable = true;
      package = pkgs.gitAndTools.gitFull;
      signing = {
        key = "friends.devon@gmail.com";
        signByDefault = true;
      };
      userName = "Devon Richards";
      userEmail = "friends.devon@gmail.com";
    };
    gnome-terminal = {
      enable = true;
      profile."0c35006c-9b3f-4ea6-80ab-380ee0228a75" = {
        allowBold = true;
        backspaceBinding = "auto";
        colors = {
          backgroundColor = colors.bg;
          boldColor = colors.invertbg;
          cursor = {
            background = colors.invertbg;
            foreground = colors.bg;
          };
          foregroundColor = colors.fg;
          highlight = {
            background = colors.brightfg;
            foreground = colors.bg;
          };
          palette = [
            colors.bg
            colors.constant
            colors.focus
            colors.constant
            colors.func
            colors.subtle
            colors.type
            colors.fg
            colors.darkfg
            colors.error
            colors.focus
            colors.warm
            colors.string
            colors.keyword
            colors.brightfg
            colors.invertbg
          ];
        };
        cursorBlinkMode = "on";
        cursorShape = "ibeam";
        default = true;
        deleteBinding = "auto";
        font = "DroidSansMono Nerd Font Mono 9";
        scrollOnOutput = true;
        scrollbackLines = -1;
        showScrollbar = false;
        visibleName = "DarkViolet";
      };
      showMenubar = true;
      themeVariant = "default";
    };
    gpg = {
      enable = true;
      settings = {
        default-key = "0x49AC0F80EE571576!";
      };
    };
    htop = {
      enable = true;
      settings = {
        fields = with config.lib.htop.fields; [
          PERCENT_CPU
          PERCENT_MEM
          M_RESIDENT
          M_PSS
          M_SIZE
          M_SHARE
          M_PSSWP
          IO_READ_RATE
          IO_WRITE_RATE
          NLWP
          STATE
          IO_PRIORITY
          PRIORITY
          NICE
          TIME
          STARTTIME
          PID
          USER
          COMM
        ];
        sort_key = config.lib.htop.fields.PERCENT_MEM;
        sort_direction = 0;
        tree_sort_key = 0;
        tree_sort_direction = 1;
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        shadow_other_users = 0;
        show_thread_names = 0;
        show_program_path = 1;
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
        highlight_changes = 1;
        highlight_changes_delay_secs = 5;
        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 1;
        tree_view = 0;
        tree_view_always_by_pid = 0;
        header_margin = 1;
        detailed_cpu_time = 1;
        cpu_count_from_one = 0;
        show_cpu_usage = 1;
        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
        degree_fahrenheit = 0;
        update_process_names = 0;
        account_guest_in_cpu_meter = 1;
        color_scheme = 6;
        enable_mouse = 1;
        delay = 5;
      } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (graph "CPU")
        (text "PressureStallCPUSome")
        (text "LoadAverage")
        (text "Tasks")
        (text "PressureStallIOFull")
        (text "DiskIO")
        (text "NetworkIO")
      ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (graph "Memory")
        (bar "Memory")
        (bar "Swap")
        (text "PressureStallMemoryFull")
        (text "Uptime")
        (text "DateTime")
      ]);
    };
    info.enable = true;
    jq.enable = true;
    kitty = {
      enable = true;
      font = {
        name = "DroidSansM Nerd Font Mono";
        size = 9;
      };
      settings = {
        background = colors.bg;
        foreground = colors.fg;
        color0     = colors.bg;
        color1     = colors.constant;
        color2     = colors.focus;
        color3     = colors.constant;
        color4     = colors.func;
        color5     = colors.subtle;
        color6     = colors.type;
        color7     = colors.fg;
        color8     = colors.darkfg;
        color9     = colors.error;
        color10    = colors.focus;
        color11    = colors.warm;
        color12    = colors.string;
        color13    = colors.keyword;
        color14    = colors.brightfg;
        color15    = colors.invertbg;
      };
    };
    lsd = {
      enable = true;
      enableAliases = true;
    };
    mcfly = {
      enable = true;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
    neovim = {
      enable = true;
      extraConfig = ''
        let g:theme_bg          = "${colors.bg}"
        let g:theme_accentbg    = "${colors.accentbg}"
        let g:theme_selectionbg = "${colors.selectionbg}"
        let g:theme_subtle      = "${colors.subtle}"
        let g:theme_darkfg      = "${colors.darkfg}"
        let g:theme_fg          = "${colors.fg}"
        let g:theme_brightfg    = "${colors.brightfg}"
        let g:theme_invertbg    = "${colors.invertbg}"
        let g:theme_error       = "${colors.error}"
        let g:theme_constant    = "${colors.constant}"
        let g:theme_type        = "${colors.type}"
        let g:theme_focus       = "${colors.focus}"
        let g:theme_string      = "${colors.string}"
        let g:theme_func        = "${colors.func}"
        let g:theme_keyword     = "${colors.keyword}"
        let g:theme_warm        = "${colors.warm}"
        lua require('lush')(dofile('${../nvim/lua}/lush_theme.lua'))
        luafile ${../nvim/lua}/settings.lua
        luafile ${../nvim/lua}/statusline_settings.lua
      '';
      extraPackages = [
        pkgs.ccls
        # pkgs.clang_15
        # pkgs.clang-tools_15
        pkgs.cmake-language-server
        pkgs.codeql
        pkgs.ltex-ls
        pkgs.nil
        pkgs.rust-analyzer
        pkgs.lua-language-server
        pkgs.taplo
        pkgs.texlab
        pkgs.xclip
        pkgs.zls
        nodePackages.bash-language-server
        nodePackages.diagnostic-languageserver
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
      ];
      extraPython3Packages = (ps: with ps; [
        pynvim
      ]);
      package = pkgs.neovim-unwrapped;
      plugins = import ./nvimplugins.nix { inherit pkgs; };
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
    };
    ssh = {
      enable = true;
      compression = true;
    };
    texlive.enable = true;
    tmux.enable = true;
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        _2gua.rainbow-brackets
        dracula-theme.theme-dracula
        mikestead.dotenv
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-python.vscode-pylance
        # ms-python.python
        redhat.vscode-yaml
        bungcip.better-toml
        njpwerner.autodocstring
      ];
      package = pkgs.vscode-fhs;
      userSettings = {
        "editor.fontFamily" = "DroidSansM Nerd Font Mono";
        "editor.fontSize" = 10;
        "terminal.integrated.fontFamily" = "DroidSansM Nerd Font Mono";
        "terminal.integrated.fontSize" = 10;
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        save = 32000;
        share = true;
        size = 65536;
      };
      initExtra = ''
        function cdn
        {
            mkdir $1
            cd $1
        }
      '';
      localVariables = {
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "context" "dir" "vcs" ];
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [ "status" "time" ];
        DISABLE_AUTO_UPDATE = "false";
        ENABLE_CORRECTION = "true";
        COMPLETION_WAITING_DOTS = "true";
        DISABLE_UNTRACKED_FILES_DIRTY = "true";
        HIST_STAMPS = "yyyy-mm-dd";
      };
      oh-my-zsh = {
        custom = "\$HOME/.zsh/plugins";
        enable = true;
        extraConfig = ''
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path ~/.zsh/cache
          zstyle ':completion:*' completer _complete _match _approximate
          zstyle ':completion:*:match:*' original only
          zstyle ':completion:*:approximate:*' max-errors 1 numeric
          zstyle -e ':completion:*:approximate:*' \
                  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
          zstyle ':completion:*:functions' ignored-patterns '_*'
        '';
        plugins = [
          "git"
          "colored-man-pages"
          "colorize"
          "compleat"
          "cp"
          "dircycle"
          "dirhistory"
          "emoji"
          "emoji-clock"
          "fasd"
          "git-extras"
          "history-substring-search"
          "kubectl"
          "pip"
          "poetry"
          "python"
          "rand-quote"
          "screen"
          "sudo"
          "tmux"
          "wd"
        ];
        theme = "powerlevel10k/powerlevel10k";
      };
      plugins = [
        {
          name = "themes/powerlevel10k";
          src = "${pkgs.zsh-powerlevel10k.outPath}/share/zsh-powerlevel10k";
        }
      ];
      shellAliases = {
        vi = "nvr --remote";
        ":q" = "exit";
        quote = "fortune";
        cow = "cowsay -W 80 -f $(python -c \"import random; print(random.choice(['beavis.zen', 'bud-frogs', 'bunny', 'cheese', 'cower', 'daemon', 'default', 'dragon', 'dragon-and-cow', 'elephant', 'elephant-in-snake', 'eyes', 'flaming-sheep', 'ghostbusters', 'hellokitty', 'kiss', 'kitty', 'koala', 'kosh', 'luke-koala', 'meow', 'milk', 'moofasa', 'moose', 'mutilated', 'ren', 'satanic', 'sheep', 'skeleton', 'small', 'stegosaurus', 'stimpy', 'surgery', 'three-eyes', 'turkey', 'turtle', 'tux', 'vader', 'vader-koala']))\")";
        cquote = "quote | cow | lolcat";
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };
  services = {
    blueman-applet.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = true;
    };
    pasystray.enable = true;
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
}
