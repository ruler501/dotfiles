{ system, nixPatch, ... }:
let
  # Easily configure a custom name, this will affect the name of the standard
  # executable, you can add as many aliases as you'd like in the configuration.
  name = "nixvim";

  # Any custom package config you would like to do.
  extra_pkg_config = {
      allowUnfree = true;
  };

  configuration = { pkgs, ... }:
  let
    patchUtils = nixPatch.patchUtils.${pkgs.stdenv.hostPlatform.system};
  in
  {
    # The path to your neovim configuration.
    luaPath = ./../nvim_config/.;

    # Plugins you use in your configuration.
    plugins = [
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-path
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.comment-nvim
      pkgs.vimPlugins.fidget-nvim
      pkgs.vimPlugins.gitsigns-nvim
      pkgs.vimPlugins.indent-blankline-nvim
      pkgs.vimPlugins.lazy-nvim
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.luasnip
      pkgs.vimPlugins.lush-nvim
      pkgs.vimPlugins.mini-icons
      pkgs.vimPlugins.neodev-nvim
      pkgs.vimPlugins.nvim-cmp
      # pkgs.vimPlugins.nvim-colorizer-lua
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter-legacy.withAllGrammars
      pkgs.vimPlugins.nvim-treesitter-textobjects
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.plenary-nvim
      # pkgs.vimPlugins.rainbow-delimiters-nvim
      # pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.trouble-nvim
      # pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-sleuth
      pkgs.vimPlugins.vim-smoothie
      pkgs.vimPlugins.which-key-nvim
    ];

    # Runtime dependencies. This is thing like tree-sitter, lsps or programs
    # like ripgrep.
    runtimeDeps = [
      pkgs.nodePackages.bash-language-server
      pkgs.llvmPackages.clang-unwrapped
      pkgs.cmake-language-server
      # pkgs.nodePackages.diagnostic-languageserver
      pkgs.docker-compose-language-service
      pkgs.docker-language-server
      pkgs.fd
      pkgs.futhark
      pkgs.gcc
      pkgs.lua-language-server
      pkgs.marksman
      pkgs.nix-doc
      pkgs.nixd
      pkgs.pyright
      pkgs.ripgrep
      pkgs.systemd-lsp
      pkgs.nodePackages.typescript-language-server
      # pkgs.nodePackages.vscode-langservers-extracted
      pkgs.wl-clipboard-rs
    ];

    # Environment variables set during neovim runtime.
    environmentVariables = { };

    # Aliases for the patched config
    aliases = [ "vim" "vi" "nvim" ];

    # Extra wrapper args you want to pass.
    # Look here if you don't know what those are:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
    extraWrapperArgs = [ ];

    # Extra python packages for the neovim provider.
    # This must be a list of functions returning lists.
    python3Packages = [ ];

    # Wrapper args but then for the python provider.
    extraPython3WrapperArgs = [ ];

    # Extra lua packages for the neovim lua runtime.
    luaPackages = [ ];

    # Extra shared libraries available at runtime.
    sharedLibraries = [ ];

    # Extra lua configuration put at the top of your init.lua
    # This cannot replace your init.lua, if none exists in your configuration
    # this will not be writtern.
    # Must be provided as a list of strings.
    extraConfig = [ ];

    # Custom subsitutions you want the patcher to make. Custom subsitutions
    # can be generated using
    customSubs = with patchUtils; [];
          # For example, if you want to add a plugin with the short url
          # "cool/plugin" which is in nixpkgs as plugin-nvim you would do:
          # ++ (patchUtils.githubUrlSub "cool/plugin" plugin-nvim);
          # If you would want to replace the string "replace_me" with "replaced"
          # you would have to do:
          # ++ (patchUtils.stringSub "replace_me" "replaced")
          # For more examples look here: https://github.com/NicoElbers/nixPatch-nvim/blob/main/subPatches.nix

    settings = {
      # Enable the NodeJs provider
      withNodeJs = true;

      # Enable the ruby provider
      withRuby = true;

      # Enable the perl provider
      withPerl = true;

      # Enable the python3 provider
      withPython3 = true;

      # Any extra name
      extraName = "";

      # The default config directory for neovim
      configDirName = "nvim";

      # Any other neovim package you would like to use, for example nightly
      neovim-unwrapped = null;

      # When using nightly, it's best to use the version nixPatch exposes,
      # this prevents potential linking errors if nixPatch isn't updated in a
      # while
      # neovim-unwrapped = inputs.nixPatch.neovim-nightly.${system};

      # Whether to add custom subsitution made in the original repo, makes for
      # a better out of the box experience
      patchSubs = true;

      # Whether to add runtime dependencies to the back of the path
      suffix-path = false;

      # Whether to add shared libraries dependencies to the back of the path
      suffix-LD = false;
    };
  };
in
nixPatch.configWrapper.${system} { inherit configuration extra_pkg_config name; }
