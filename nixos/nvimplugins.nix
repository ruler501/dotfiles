{ pkgs }:
let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
  plugins = pkgs.vimPlugins;
in
[
  {
    plugin = buildVimPlugin {
      pname = "animate.vim";             # Animate changing window sizes.
      version = "ca124da";
      src = pkgs.fetchFromGitHub {
        owner = "camspiers";
        repo = "animate.vim";
        rev = "ca124da441b4d4ea721f33a999d4493e0d0a7a31";
        sha256 = "sha256-Nc1DkNGgSeHWKcS9G7u0r4HVGs9pPR0nUECSt0OlYFs=";
      };
      meta.homepage = "https://github.com/camspiers/animate.vim";
    };
  }
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
  plugins.legendary-nvim
  plugins.lsp_lines-nvim
  plugins.lsp-colors-nvim
  plugins.lsp-format-nvim                      # Do autoformatting with LSP.
  plugins.lualine-lsp-progress
  plugins.lualine-nvim
  plugins.lush-nvim
  plugins.nvim-base16
  plugins.nvim-colorizer-lua
  plugins.nvim-cmp
  # nvim-dap
  # nvim-dap-ui
  # nvim-dap-virtual-text
  plugins.nvim-lspconfig
  plugins.nvim-nonicons
  plugins.nvim-snippy
  (plugins.nvim-treesitter.withPlugins (p: [ # Install just what's needed so we can avoid potential build failures.
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
    p.help
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
  ]))
  plugins.nvim-treesitter-context
  plugins.nvim-ts-autotag
  plugins.nvim-ts-context-commentstring
  plugins.nvim-ts-rainbow
  plugins.nvim-web-devicons
  plugins.plenary-nvim
  plugins.SchemaStore-nvim
  plugins.symbols-outline-nvim
  plugins.tabline-nvim
  plugins.telescope-nvim
  plugins.telescope-frecency-nvim
  plugins.telescope-fzy-native-nvim
  plugins.telescope-lsp-handlers-nvim
  {
    plugin = buildVimPlugin {
      pname = "tidy.nvim";             # Autoclean trailing whitespace.
      version = "4dcb511";
      src = pkgs.fetchFromGitHub {
        owner = "mcauley-penney";
        repo = "tidy.nvim";
        rev = "4dcb51102eefa3485957add8d8c8cfa4953718d1";
        sha256 = "sha256-G1EE9tuiC3dFu1v08o0zSHY/T2xSiWL0N6dzkdSBsWY=";
      };
      meta.homepage = "https://github.com/mcauley-penney/tidy.nvim";
    };
  }
  plugins.trouble-nvim
  plugins.vim-fetch                              # Allow opening to specific lines and columns.
  plugins.vim-fugitive
  plugins.vim-gitgutter                          # Show git status in the gutter.
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
  plugins.vim-matchup
  plugins.vim-mundo                              # Visual undo history as a tree.
  plugins.vim-nix                                # Add support for the Nix language to Neovim.
  plugins.vim-rooter                             # Change directory to project root automatically.
  {
    plugin = buildVimPlugin {
      pname = "vim-rzip";        # View and edit files in zip archives.
      version = "e749429";
      src = pkgs.fetchFromGitHub {
        owner = "lbrayner";
        repo = "vim-rzip";
        rev = "e749429df203ae5133edef87b51f174a6448886d";
        sha256 = "sha256-l1MR2FXnKmzvkg8GkkJ1Ncp3MMOObvXX3fjyF7ecuyE=";
      };
      meta.homepage = "https://github.com/lbrayner/vim-rzip";
    };
  }
  plugins.vim-smoothie                           # Smooth scrolling.
  plugins.vim-startify                           # Fancy start page.
  plugins.which-key-nvim
]
