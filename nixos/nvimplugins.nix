{ pkgs }:
let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
  plugins = pkgs.vimPlugins;
  treesitter = (plugins.nvim-treesitter.withPlugins (p: [ # Install just what's needed so we can avoid potential build failures.
    p.dockerfile
    p.json
    p.vim
    p.haskell
    p.kotlin
    p.lua
    p.latex
    p.gitcommit
    p.rust
    p.python
    p.java
    p.jsonnet
    p.graphql
    p.json5
    p.cmake
    p.jsdoc
    p.javascript
    p.todotxt
    p.html
    p.c
    p.css
    p.git_rebase
    p.markdown_inline
    p.nix
    p.markdown
    p.cuda
    p.pug
    p.dot
    p.awk
    p.bash
    p.jsonc
    p.jq
    p.comment
    p.ebnf
    p.diff
    p.gitattributes
    p.tsx
    p.toml
    p.yaml
    p.llvm
    p.c_sharp
    p.http
    p.cpp
    p.ninja
    p.zig
    p.regex
    p.bibtex
    p.make
  ]));
in
[
  plugins.ccc-nvim                                   # Color code picker with multiple color spaces
  plugins.clangd_extensions-nvim
  plugins.cmp-buffer
  plugins.cmp-cmdline
  plugins.cmp-latex-symbols
  plugins.cmp-nvim-lsp
  plugins.cmp-nvim-lua
  plugins.cmp-path
  plugins.cmp-snippy
  plugins.cmp-treesitter
  plugins.cmp-under-comparator
  plugins.comment-nvim
  plugins.compiler-explorer-nvim
  plugins.diffview-nvim
  plugins.dressing-nvim
  plugins.lean-nvim
  plugins.legendary-nvim
  plugins.lsp-colors-nvim
  plugins.lsp-format-nvim                      # Do autoformatting with LSP.
  plugins.lsp_lines-nvim
  plugins.lualine-lsp-progress
  plugins.lualine-nvim
  plugins.lush-nvim
  plugins.markdown-preview-nvim
  plugins.nvim-base16
  plugins.nvim-cmp
  plugins.nvim-colorizer-lua
  plugins.nvim-lspconfig
  plugins.nvim-nonicons
  plugins.nvim-snippy
  plugins.nvim-treesitter-context
  plugins.nvim-ts-autotag
  plugins.nvim-ts-context-commentstring
  plugins.nvim-web-devicons
  plugins.plenary-nvim
  plugins.SchemaStore-nvim
  plugins.symbols-outline-nvim
  plugins.tabline-nvim
  plugins.telescope-frecency-nvim
  plugins.telescope-fzy-native-nvim
  plugins.telescope-lsp-handlers-nvim
  plugins.telescope-nvim
  plugins.trouble-nvim
  plugins.vim-fetch                              # Allow opening to specific lines and columns.
  plugins.vim-fugitive
  plugins.vim-gitgutter                          # Show git status in the gutter.
  plugins.vim-matchup
  plugins.vim-mundo                              # Visual undo history as a tree.
  plugins.vim-nix                                # Add support for the Nix language to Neovim.
  plugins.vim-rooter                             # Change directory to project root automatically.
  plugins.vim-smoothie                           # Smooth scrolling.
  plugins.vim-startify                           # Fancy start page.
  plugins.which-key-nvim
  plugins.gitsigns-nvim
  plugins.nvim-scrollbar
  plugins.nvim-ts-rainbow2
  treesitter
  {
    plugin = buildVimPlugin {
      pname = "nvim-retrail";             # Autoclean trailing whitespace.
      version = "d04fdf1";
      src = pkgs.fetchFromGitHub {
        owner = "kaplanz";
        repo = "nvim-retrail";
        rev = "d04fdf1524057e9d8956a1f6aada9a23abd7a476";
        sha256 = "sha256-G1EE9tuiC3dFu1v08o0zSHY/T2xSiWL0N6dzkdSBsWY=";
      };
      meta.homepage = "https://github.com/kaplanz/nvim-retrail";
    };
  }
  {
    plugin = buildVimPlugin {
      pname = "vim-indentguides";        # Indentation guides.
      version = "359f35e";
      src = pkgs.fetchFromGitHub {
        owner = "thaerkh";
        repo = "vim-indentguides";
        rev = "3152f3a0604089d545983b72e7cb676898bb7da1";
        sha256 = "sha256-l1MR2FXnKmzvkg8GkkJ1Ncp3MMOObvXX3fjyF7ecuyE=";
      };
      meta.homepage = "https://github.com/thaerkh/vim-indentguides";
    };
  }
  {
    plugin = buildVimPlugin {
      pname = "buffertag";                   # Show names of inactive buffers in floating windows.
      version = "59df485";
      src = pkgs.fetchFromGitHub {
        owner = "ldelossa";
        repo = "buffertag";
        rev = "59df48544585695da3439d78f3d816461797c592";
        sha256 = "sha256-4K3YljnhE7ZgkMZHbXe7tuFghMIPHMNw1I568Eo4xqU=";
      };
      meta.homepage = "https://github.com/ldelossa/buffertag";
    };
  }
  {
    plugin = buildVimPlugin {
      pname = "nvim-file-location";          # Allow copying current filename and location in file.
      version = "1.1.0";
      src = pkgs.fetchFromGitHub {
        owner = "diegoulloao";
        repo = "nvim-file-location";
        rev = "e995e5755f1a8301b734b8a3d4c5218dd3d5cd6e";
        sha256 = "sha256-/YuuQh8VGm4bpZYzKplPAM+Xzr65U07KzaDxuD4KP5c=";
      };
      meta.homepage = "https://github.com/diegoulloao/nvim-file-location";
    };
  }
  {
    plugin = buildVimPlugin {
      pname = "buffer-manager-nvim";          # Ease moving between open buffers
      version = "03b6bdf";
      src = pkgs.fetchFromGitHub {
        owner = "j-morano";
        repo = "buffer_manager.nvim";
        rev = "03b6bdfa7379ac1c458264b2db1c95b78434bb2c";
        sha256 = "sha256-BJschPEE5gv9v714ap7XaEumfpj/5lndbdexd+4MySU=";
      };
      meta.homepage = "https://github.com/j-morano/buffer_manager.nvim";
    };
  }
  {
    plugin = buildVimPlugin {
      pname = "nvim-possession";          # Session management
      version = "0.0.7";
      src = pkgs.fetchFromGitHub {
        owner = "gennaro-tedesco";
        repo = "nvim-possession";
        rev = "cd16248a5bf97b87597f554b015b20d6275c412c";
        sha256 = "sha256-EHihjUtJG++E9oixLyqRua9vF7USMca6ARvwn6boieU=";
      };
      meta.homepage = "https://github.com/gennaro-tedesco/nvim-possession";
    };
  }

  # Investigate when have time
  # nvim-dap
  # nvim-dap-ui
  # nvim-dap-virtual-text

  # Check whether these become available
  # https://github.com/0x100101/lab.nvim
  # https://github.com/DaikyXendo/nvim-material-icon
  # https://github.com/barrett-ruth/import-cost.nvim
  # https://github.com/jose-elias-alvarez/typescript.nvim
  # https://github.com/jrop/mongo.nvim
  # https://github.com/marilari88/twoslash-queries.nvim
  # https://github.com/mong8se/actually.nvim
  # https://github.com/phaazon/notisys.nvim
  # https://github.com/riddlew/swap-split.nvim
  # https://github.com/luukvbaal/statuscol.nvim
  # https://github.com/RaafatTurki/hex.nvim
  # https://github.com/jcdickinson/wpm.nvim
]
