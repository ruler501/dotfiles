{ config, pkgs, nonicons, lib, secrets, colors, ... }@inputs:
{ 
  imports = [ ];
  config = {
    home = {
      activation = {
        pnpm-global = lib.hm.dag.entryAfter["writeBoundary"] "
          mkdir -p /home/devon/.pnpm_global ";
      };
      file = { ".config/fonts/nonicons.ttf".source = "${nonicons.outPath}/dist/nonicons.ttf"; ".zsh/plugins/plugins/poetry/_poetry".source = ../_poetry; ".pdbrc".source = ../pdbrc; 
        ".gnupg/sshcontrol".text = secrets.gnupg.sshcontrol;
      };
      homeDirectory = "/home/devon"; keyboard.options = [ "ctrl:nocaps" ]; sessionPath = [
        "$HOME/.npm-global/bin"
      ]; stateVersion = "23.11"; username = "devon";
    };
    programs = {
      # command-not-found.enable = true;
      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          side-by-side = true;
        };
      };
      dircolors = {
        enable = true; enableZshIntegration = true;
      };
      direnv = { config = {
          load_dotenv = false;
        };
        enable = true; nix-direnv = {
          enable = true;
        };
        enableZshIntegration = true;
      };
      firefox.profiles = {};
      git = {
        enable = true;
        includes = [ {
            path = "~/.gnupg/.git-userconfig";
          }
        ];
        lfs.enable = true;
        settings = {
          color = {
            ui = true;
          };
          column = { ui = "auto";
          };
          core = { editor = "vim"; eol = "lf";
            # excludesfile = ../ruler501.gitignore;
          };
          init = { defaultBranch = "develop";
          };
          merge = { tool = "vim_mergetool"; conflictstyle = "diff3";
          };
          mergetool = { keepBackup = false;
          };
          "mergetool \"vim_mergetool\"" = { cmd = "nvr --remote-wait -c \"DiffviewOpen\""; trustExitCode = false;
          };
          pull = { rebase = true;
          };
          user = {
            name = "Sabia Richards";
            email = "friends.devon@gmail.com";
          };
        };
        signing = {
          key = "friends.devon@gmail.com"; signByDefault = true;
        };
      };
      gnome-terminal = { enable = true; profile."0c35006c-9b3f-4ea6-80ab-380ee0228a75" = {
          allowBold = true; backspaceBinding = "auto"; colors = {
            backgroundColor = colors.named.bg; boldColor = colors.named.invertbg; cursor = {
              background = colors.named.invertbg; foreground = colors.named.bg;
            };
            foregroundColor = colors.named.fg; highlight = {
              background = colors.named.brightfg; foreground = colors.named.bg;
            };
            palette = [ colors.named.bg colors.named.constant colors.named.focus colors.named.constant colors.named.func colors.named.subtle colors.named.type colors.named.fg 
              colors.named.darkfg colors.named.error colors.named.focus colors.named.warm colors.named.string colors.named.keyword colors.named.brightfg colors.named.invertbg
            ];
          };
          cursorBlinkMode = "on"; cursorShape = "ibeam"; default = true; deleteBinding = "auto"; font = "DroidSansMono Nerd Font Mono 9"; scrollOnOutput = true; scrollbackLines = -1; 
          showScrollbar = false; visibleName = "DarkViolet";
        };
        showMenubar = true; themeVariant = "default";
      };
      gpg = { enable = true; settings = {
          default-key = "0x49AC0F80EE571576!";
        };
      };
      htop = { enable = true; settings = {
          fields = with config.lib.htop.fields; [
            PERCENT_CPU PERCENT_MEM M_RESIDENT M_PSS M_SIZE M_SHARE M_PSSWP IO_READ_RATE IO_WRITE_RATE NLWP STATE IO_PRIORITY PRIORITY NICE TIME STARTTIME PID USER COMM
          ]; sort_key = config.lib.htop.fields.PERCENT_MEM; sort_direction = 0; tree_sort_key = 0; tree_sort_direction = 1; hide_kernel_threads = 1; hide_userland_threads = 1; 
          shadow_other_users = 0; show_thread_names = 0; show_program_path = 1; highlight_base_name = 1; highlight_megabytes = 1; highlight_threads = 1; highlight_changes = 1; 
          highlight_changes_delay_secs = 5; find_comm_in_cmdline = 1; strip_exe_from_cmdline = 1; show_merged_command = 1; tree_view = 0; tree_view_always_by_pid = 0; header_margin = 1; 
          detailed_cpu_time = 1; cpu_count_from_one = 0; show_cpu_usage = 1; show_cpu_frequency = 1; show_cpu_temperature = 1; degree_fahrenheit = 0; update_process_names = 0; 
          account_guest_in_cpu_meter = 1; color_scheme = 6; enable_mouse = 1; delay = 5;
        } // (with config.lib.htop; leftMeters [
          (bar "LeftCPUs2") (graph "CPU") (text "PressureStallCPUSome") (text "LoadAverage") (text "Tasks") (text "PressureStallIOFull") (text "DiskIO") (text "NetworkIO")
        ]) // (with config.lib.htop; rightMeters [
          (bar "RightCPUs2") (graph "Memory") (bar "Memory") (bar "Swap") (text "PressureStallMemoryFull") (text "Uptime") (text "DateTime")
        ]);
      };
      info.enable = true; jq.enable = true; kitty = {
        enable = true;
      };
      lsd = { enable = true; enableZshIntegration = true;
      };
      mcfly = { enable = true; enableZshIntegration = true; keyScheme = "vim";
      };
      ssh = {
        enable = true;
        # compression = true;
      };
      texlive.enable = true;
      tmux.enable = true;
      vscode = {
        enable = true;
        profiles.default = {
          extensions = [
            pkgs.vscode-extensions."2gua".rainbow-brackets pkgs.vscode-extensions.dracula-theme.theme-dracula pkgs.vscode-extensions.mikestead.dotenv 
            pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools pkgs.vscode-extensions.ms-python.vscode-pylance
            # pkgs.vscode-extensions.ms-python.python
            pkgs.vscode-extensions.redhat.vscode-yaml pkgs.vscode-extensions.bungcip.better-toml pkgs.vscode-extensions.njpwerner.autodocstring
          ];
          userSettings = {};
        };
        package = pkgs.vscode-fhs;
      };
      zsh = {
        autosuggestion = { enable = true;
        };
        enable = true; enableCompletion = true; enableVteIntegration = true; history = {
          expireDuplicatesFirst = true; extended = true; ignoreDups = true; ignoreSpace = true; save = 32000; share = true; size = 65536;
        };
        initContent = '' function cdn {
              mkdir $1 cd $1
          }

          export TIMEFMT='%J %U user %S system %P cpu %*E total'$'\n'\ 'avg shared (code): %X KB'$'\n'\ 'avg unshared (data/stack): %D KB'$'\n'\ 'total (sum): %K KB'$'\n'\ 'max memory: %M 
          'MB''$'\n'\ 'page faults from disk: %F'$'\n'\ 'other page faults: %R'
        ''; localVariables = {
          POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "context" "dir" "vcs" ]; POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [ "status" "time" ]; DISABLE_AUTO_UPDATE = "false"; ENABLE_CORRECTION = "true"; 
          COMPLETION_WAITING_DOTS = "true"; DISABLE_UNTRACKED_FILES_DIRTY = "true"; HIST_STAMPS = "yyyy-mm-dd";
        };
        oh-my-zsh = { custom = "\$HOME/.zsh/plugins"; enable = true; extraConfig = ''
            zstyle ':completion:*' use-cache on zstyle ':completion:*' cache-path ~/.zsh/cache zstyle ':completion:*' completer _complete _match _approximate zstyle ':completion:*:match:*' 
            original only zstyle ':completion:*:approximate:*' max-errors 1 numeric zstyle -e ':completion:*:approximate:*' \
                    max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)' zstyle ':completion:*:functions' ignored-patterns '_*'
          ''; plugins = [
            "git" "colored-man-pages" "colorize" "compleat" "cp" "dircycle" "dirhistory" "emoji" "emoji-clock" "fasd" "git-extras" "history-substring-search" "kubectl" "pip" "poetry" 
            "python" "rand-quote" "screen" "sudo" "tmux" "wd"
          ]; theme = "powerlevel10k/powerlevel10k";
        };
        plugins = [ {
            name = "themes/powerlevel10k"; src = "${pkgs.zsh-powerlevel10k.outPath}/share/zsh-powerlevel10k";
          }
        ]; shellAliases = {
          vi = "nvr --remote"; ":q" = "exit"; quote = "fortune"; cow = "cowsay -W 80 -f $(python -c \"import random; print(random.choice(['beavis.zen', 'bud-frogs', 'bunny', 'cheese', 
          'cower', 'daemon', 'default', 'dragon', 'dragon-and-cow', 'elephant', 'elephant-in-snake', 'eyes', 'flaming-sheep', 'ghostbusters', 'hellokitty', 'kiss', 'kitty', 'koala', 'kosh', 
          'luke-koala', 'meow', 'milk', 'moofasa', 'moose', 'mutilated', 'ren', 'satanic', 'sheep', 'skeleton', 'small', 'stegosaurus', 'stimpy', 'surgery', 'three-eyes', 'turkey', 'turtle', 
          'tux', 'vader', 'vader-koala']))\")"; cquote = "quote | cow | lolcat";
        };
      };
    };
    qt = { enable = true; platformTheme.name = "adwaita-dark"; style = {
        package = pkgs.adwaita-qt; name = "adwaita-dark";
      };
    };
    services = { blueman-applet.enable = true; gpg-agent = {
        enable = true; enableSshSupport = true; grabKeyboardAndMouse = true;
        pinentry.package = pkgs.pinentry-qt; # Needed on unstable, not supported on stable.
      };
      pasystray.enable = true;
    };
    xdg = { enable = true; mime.enable = true;
    };
  };
}
