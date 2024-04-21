{ config, pkgs, nonicons, lib, secrets, colors, ... }@inputs:
let
  nodePackages = pkgs.nodePackages;
  utils = inputs.nixCats.utils;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      # these are some of the options. For the rest see
      # :help nixCats.flake.outputs.utils.mkNixosModules
      # you do not need to use every option here, anything you do not define
      # will be pulled from the flake instead.
      enable = true;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = (import ./nixcat-overlays inputs) ++ [
        (utils.standardPluginOverlay inputs)
      ];
      packageNames = [ "myHomeModuleNvim" ];

      luaPath = "${./../nvim/nixcats/.}";
      # you could also import lua from the flake though, by not including this.

      # categoryDefinitions.replace will replace the whole categoryDefinitions with a new one
      categoryDefinitions.replace = ({ pkgs, settings, categories, name, ... }: {
        propagatedBuildInputs = {
          # add to general or create a new list called whatever
          general = [];
        };
        lspsAndRuntimeDeps = {
          general = [
            pkgs.fd
            pkgs.gcc
            pkgs.lua-language-server
            pkgs.nil
            pkgs.nix-doc
            pkgs.nixd
            pkgs.ripgrep
            pkgs.universal-ctags
            pkgs.xclip
            nodePackages.bash-language-server
            nodePackages.diagnostic-languageserver
            nodePackages.pyright
            nodePackages.typescript-language-server
            nodePackages.vscode-langservers-extracted
          ];
        };
        startupPlugins = {
          lazy = [ pkgs.vimPlugins.lazy-nvim ];
          general = {
            gitPlugins = [ pkgs.neovimPlugins.hlargs ];

            vimPlugins = [
              pkgs.vimPlugins.neodev-nvim
              pkgs.vimPlugins.neoconf-nvim
              pkgs.vimPlugins.nvim-cmp
              pkgs.vimPlugins.luasnip
              pkgs.vimPlugins.cmp_luasnip
              pkgs.vimPlugins.cmp-path
              pkgs.vimPlugins.cmp-nvim-lsp
              pkgs.vimPlugins.telescope-fzf-native-nvim
              pkgs.vimPlugins.plenary-nvim
              pkgs.vimPlugins.telescope-nvim
              pkgs.vimPlugins.nvim-treesitter-textobjects
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              pkgs.vimPlugins.nvim-lspconfig
              pkgs.vimPlugins.fidget-nvim
              pkgs.vimPlugins.lualine-nvim
              pkgs.vimPlugins.gitsigns-nvim
              pkgs.vimPlugins.which-key-nvim
              pkgs.vimPlugins.comment-nvim
              pkgs.vimPlugins.vim-sleuth
              pkgs.vimPlugins.vim-fugitive
              pkgs.vimPlugins.indent-blankline-nvim
              pkgs.vimPlugins.lush-nvim
              pkgs.vimPlugins.vim-smoothie
              pkgs.vimPlugins.nvim-colorizer-lua
              pkgs.vimPlugins.rainbow-delimiters-nvim
            ];
          };
        };
        optionalPlugins = {
          general = [];
        };
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = [
            # pkgs.libgit2
          ];
        };
        environmentVariables = {
          test = {};
        };
        extraWrapperArgs = {
          test = [];
        };
        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages

        # get the path to this python environment
        # in your lua config via
        # vim.g.python3_host_prog
        # or run from nvim terminal via :!<packagename>-python3
        extraPython3Packages = {
          test = (_:[]);
        };
        extraPythonPackages = {
          test = (_:[]);
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [ (_:[]) ];
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packages = {
        # These are the names of your packages
        # you can include as many as you wish.
        myHomeModuleNvim = {pkgs , ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # you may not alias to nvim
            # your alias may not conflict with your other packages.
            aliases = [ "vim" "homeVim" ];
            # caution: this option must be the same for all packages.
            # nvimSRC = inputs.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            general = true;
            test = true;
            colors = colors.named;
          };
        };
      };
    };
    home = {
      activation = {
        pnpm-global = lib.hm.dag.entryAfter["writeBoundary"] "
          mkdir -p /home/devon/.pnpm_global
        ";
      };
      file = {
        ".config/fonts/nonicons.ttf".source = "${nonicons.outPath}/dist/nonicons.ttf";
        ".zsh/plugins/plugins/poetry/_poetry".source = ../_poetry;
        ".pdbrc".source = ../pdbrc;
        ".gnupg/sshcontrol".text = secrets.gnupg.sshcontrol;
      };
      homeDirectory = "/home/devon";
      keyboard.options = [ "ctrl:nocaps" ];
      sessionPath = [
        "$HOME/.npm-global/bin"
      ];
      stateVersion = "23.11";
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
            backgroundColor = colors.named.bg;
            boldColor = colors.named.invertbg;
            cursor = {
              background = colors.named.invertbg;
              foreground = colors.named.bg;
            };
            foregroundColor = colors.named.fg;
            highlight = {
              background = colors.named.brightfg;
              foreground = colors.named.bg;
            };
            palette = [
              colors.named.bg
              colors.named.constant
              colors.named.focus
              colors.named.constant
              colors.named.func
              colors.named.subtle
              colors.named.type
              colors.named.fg
              colors.named.darkfg
              colors.named.error
              colors.named.focus
              colors.named.warm
              colors.named.string
              colors.named.keyword
              colors.named.brightfg
              colors.named.invertbg
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
      # neovim = {
      #   enable = true;
      #   extraConfig = ''
      #     let g:theme_bg          = "${colors.named.bg}"
      #     let g:theme_accentbg    = "${colors.named.accentbg}"
      #     let g:theme_selectionbg = "${colors.named.selectionbg}"
      #     let g:theme_subtle      = "${colors.named.subtle}"
      #     let g:theme_darkfg      = "${colors.named.darkfg}"
      #     let g:theme_fg          = "${colors.named.fg}"
      #     let g:theme_brightfg    = "${colors.named.brightfg}"
      #     let g:theme_invertbg    = "${colors.named.invertbg}"
      #     let g:theme_error       = "${colors.named.error}"
      #     let g:theme_constant    = "${colors.named.constant}"
      #     let g:theme_type        = "${colors.named.type}"
      #     let g:theme_focus       = "${colors.named.focus}"
      #     let g:theme_string      = "${colors.named.string}"
      #     let g:theme_func        = "${colors.named.func}"
      #     let g:theme_keyword     = "${colors.named.keyword}"
      #     let g:theme_warm        = "${colors.named.warm}"
      #     lua require('lush')(dofile('${../nvim}/lush_theme.lua'))
      #     luafile ${../nvim}/settings.lua
      #     luafile ${../nvim}/statusline_settings.lua
      #   '';
      #   extraPackages = [
      #     pkgs.ccls
      #     pkgs.cmake-language-server
      #     pkgs.codeql
      #     pkgs.ltex-ls
      #     pkgs.nil
      #     pkgs.rust-analyzer
      #     pkgs.lua-language-server
      #     pkgs.taplo
      #     pkgs.texlab
      #     pkgs.xclip
      #     pkgs.zls
      #     nodePackages.bash-language-server
      #     nodePackages.diagnostic-languageserver
      #     nodePackages.dockerfile-language-server-nodejs
      #     nodePackages.pyright
      #     nodePackages.typescript-language-server
      #     nodePackages.vim-language-server
      #     nodePackages.vscode-langservers-extracted
      #     nodePackages.yaml-language-server
      #   ];
      #   extraPython3Packages = (ps: [
      #     ps.pynvim
      #   ]);
      #   package = pkgs.neovim-unwrapped;
      #   plugins = import ./nvimplugins.nix { inherit pkgs; };
      #   vimAlias = true;
      #   vimdiffAlias = true;
      #   withNodeJs = true;
      #   withPython3 = true;
      # };
      ssh = {
        enable = true;
        compression = true;
      };
      texlive.enable = true;
      tmux.enable = true;
      vscode = {
        enable = true;
        extensions = [
          pkgs.vscode-extensions._2gua.rainbow-brackets
          pkgs.vscode-extensions.dracula-theme.theme-dracula
          pkgs.vscode-extensions.mikestead.dotenv
          pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
          pkgs.vscode-extensions.ms-python.vscode-pylance
          # pkgs.vscode-extensions.ms-python.python
          pkgs.vscode-extensions.redhat.vscode-yaml
          pkgs.vscode-extensions.bungcip.better-toml
          pkgs.vscode-extensions.njpwerner.autodocstring
        ];
        package = pkgs.vscode-fhs;
        userSettings = {};
      };
      zsh = {
        # autosuggestion = {
        #   enable = true;
        # };
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
        pinentryFlavor = "qt";
        # pinentryPackage = pkgs.pinentry-qt; # Needed on unstable, not supported on stable.
      };
      pasystray.enable = true;
    };
    xdg = {
      enable = true;
      mime.enable = true;
    };
  };
}
