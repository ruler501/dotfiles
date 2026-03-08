-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

----------------------------
-- UTILS
----------------------------
local set = function(nonNix, nix)
    if vim.g.nix == true then
        return nix
    else
        return nonNix
    end
end
local isNix = set(false, true)

-- Bootstrap lazy.nvim
local load_lazy_non_nix = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
end

local load_lazy_nix = function()
    -- Prepend the runtime path with the directory of lazy
    -- This means we can call `require("lazy")`
    vim.opt.rtp:prepend([[lazy.nvim-plugin-path]])
end

local load_lazy = set(load_lazy_non_nix, load_lazy_nix)

-- Actually execute the loading function we set above
load_lazy()

----------------------------
-- LAZY CONFIG
----------------------------
local lush_config = {
  'rktjmp/lush.nvim',
  lazy = false,
  config = function()
    require('lush')(require('lush_theme/darkviolet'));
  end,
}

--[[ ------------------------------------------- ]]
--[[ this is just the options set that is passed ]]
--[[ in as the second argument to the normal     ]]
--[[ require('lazy').setup({},{}) function.      ]]
--[[ ------------------------------------------- ]]
local lazyOptions = {
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  performance = { rtp = { reset = set(true, false) } }
}

--[[ ------------------------------------------- ]]
--[[ and now we call our wrapper, passing it our ]]
--[[ plugin name list(or table),                 ]]
--[[ and our lazypath when loaded via nix.       ]]
--[[ after that we just pass in the normal 2     ]]
--[[ remaining arguments to the lazy setup()     ]]
--[[ ------------------------------------------- ]]
require('lazy').setup(
  {
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    -- {
    --   'tpope/vim-fugitive',
    -- },

    -- Detect tabstop and shiftwidth automatically
    -- {
    --   'tpope/vim-sleuth',
    -- },

    -- {
    --   'HiPhish/rainbow-delimiters.nvim',
    --   config = function ()
    --     -- This module contains a number of default definitions
    --     local rainbow_delimiters = require 'rainbow-delimiters'
    --     ---@type rainbow_delimiters.config
    --     vim.g.rainbow_delimiters = {
    --       strategy = {
    --         [''] = rainbow_delimiters.strategy['global'],
    --         vim = rainbow_delimiters.strategy['local'],
    --       },
    --       query = {
    --         [''] = 'rainbow-delimiters',
    --         lua = 'rainbow-blocks',
    --       },
    --       priority = {
    --         [''] = 110,
    --         lua = 210,
    --       },
    --       highlight = {
    --         'rainbowcol1',
    --         'rainbowcol2',
    --         'rainbowcol3',
    --         'rainbowcol4',
    --         'rainbowcol5',
    --         'rainbowcol6',
    --         'rainbowcol7',
    --       },
    --     }
    --   end,
    --   dependencies = {
    --     lush_config,
    --   },
    -- },

    -- {
    --   'NvChad/nvim-colorizer.lua',
    --   main = "colorizer",
    --   opts = {
    --     filetypes = { '*' },
    --     user_default_options = {
    --       RGB = false,
    --       RRGGBB = true,
    --       names = false,
    --       RRGGBBAA = true,
    --       rgb_fn = true,
    --       hsl_fn = true,
    --       css = false,
    --       css_fn = false,
    --       mode = "virtualtext",
    --       tailwind = false,
    --       sass = { enable = false, parsers = {}, },
    --       virtualtext = "■",
    --     },
    --     buftypes = {},
    --   },
    -- },

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    -- {
    --   -- LSP Configuration & Plugins
    --   'neovim/nvim-lspconfig',
    --   dependencies = {
    --     -- Automatically install LSPs to stdpath for neovim
    --     --[[ ----------------------------------------- ]]
    --     --[[ Uh-oh! We don't want to use mason on nix! ]]
    --     --[[ luckily we have our lazyAdd utility!      ]]
    --     --[[ We can use it to add true only if not     ]]
    --     --[[ loaded via nix.                           ]]
    --     --[[ When NOT loaded in nix                    ]]
    --     --[[ It returns the 1st value, otherwise,      ]]
    --     --[[ it returns the 2nd value.                 ]]
    --     --[[    (or nil if there wasnt one)            ]]
    --     --[[ ----------------------------------------- ]]
    --     {
    --       'williamboman/mason.nvim',
    --       enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false),
    --     },
    --     {
    --       'williamboman/mason-lspconfig.nvim',
    --       enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false),
    --     },
    --
    --     -- Useful status updates for LSP
    --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --     {
    --       'j-hui/fidget.nvim', opts = {},
    --     },
    --
    --     -- Additional lua configuration, makes nvim stuff amazing!
    --     {
    --       'folke/neodev.nvim',
    --     },
    --     {
    --       'folke/neoconf.nvim',
    --     },
    --   },
    -- },

    {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = {
        --[[ ------------------------------------- ]]
        --[[ Uh-oh! This one has a different name! ]]
        --[[ Set the name to the actual filename   ]]
        --[[ that was generated by nix. Lazy will  ]]
        --[[ use the same name in non-nix installs ]]
        --[[ this ensures that your config won't   ]]
        --[[ break from this on non-nix OS targets ]]
        --[[ ------------------------------------- ]]
        {
          'L3MON4D3/LuaSnip',
          name = 'luasnip'
        },
        {
          'saadparwaiz1/cmp_luasnip',
        },
        -- Adds LSP completion capabilities
        {
          'hrsh7th/cmp-nvim-lsp',
        },
        {
          'hrsh7th/cmp-path',
        },
      },
    },

    -- Useful plugin to show you pending keybinds.
    {
      'folke/which-key.nvim', opts = {},
    },
    {
      -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to next hunk' })

          map({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to previous hunk' })

          -- Actions
          -- visual mode
          map('v', '<leader>hs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'stage git hunk' })
          map('v', '<leader>hr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'reset git hunk' })
          -- normal mode
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
          map('n', '<leader>hb', function()
            gs.blame_line { full = false }
          end, { desc = 'git blame line' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
          map('n', '<leader>hD', function()
            gs.diffthis '~'
          end, { desc = 'git diff against last commit' })

          -- Toggles
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
          map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
        end,
      },
    },
    {
      -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      -- See `:help lualine.txt`
      opts = {
        options = {
          icons_enabled = false,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
      },
    },

    {
      -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help ibl`
      main = 'ibl',
      config = function ()
        local hooks = require('ibl.hooks')
        require('ibl').setup({
          indent = { highlight = { 'IndentGuide' }, char = '┆', },
          whitespace = { highlight = { 'Whitespace' }, remove_blankline_trail = false, },
          scope = { highlight = { 'rainbowcol1', 'rainbowcol2', 'rainbowcol3', 'rainbowcol4', 'rainbowcol5',
                                  'rainbowcol6', 'rainbowcol7', }, },
        })
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      end,
      dependencies = {
        lush_config,
      },
    },

    -- "gc" to comment visual regions/lines
    {
      'numToStr/Comment.nvim', opts = {}, name = 'comment.nvim'
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        {
          'nvim-lua/plenary.nvim',
        },
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        -- {
        --   'nvim-telescope/telescope-fzf-native.nvim',
        --   -- NOTE: If you are having trouble with this installation,
        --   --       refer to the README for telescope-fzf-native for more instructions.
        --   --[[ --------------------------------- ]]
        --   --[[ Uh-oh! This one has a build step! ]]
        --   --[[ Nix has already done that for us. ]]
        --   --[[ Use the lazyAdd function to       ]]
        --   --[[ disable build steps on nix.       ]]
        --   --[[ --------------------------------- ]]
        --   build = require('nixCatsUtils.lazyCat').lazyAdd('make'),
        --   cond = require('nixCatsUtils.lazyCat').lazyAdd(function()
        --     return vim.fn.executable 'make' == 1
        --   end),
        -- },
      },
    },

    {
      -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        {
          'nvim-treesitter/nvim-treesitter-textobjects',
        },
      },
      -- build = require('nixCatsUtils.lazyCat').lazyAdd(':TSUpdate'),
    },
    -- {
    --   'm-demare/hlargs.nvim',
    --   name = 'hlargs',
    --   config = function()
    --     require('hlargs').setup({
    --       color = '#32a88f',
    --     })
    --     vim.cmd([[
    --     highlight clear @lsp.type.parameter
    --     highlight link @lsp.type.parameter Hlargs
    --   ]])
    --   end,
    -- },
    {
      'psliwka/vim-smoothie',
      lazy = false,
    }
  }, lazyOptions)


----------------------------
-- NEOVIM OPTIONS
----------------------------
-- See `:help vim.o`

vim.o.autochdir = false                 -- Don't change directories automatically.
vim.o.autoread = true                   -- Auto reload if no changes in buffer.
vim.o.autowrite = false                 -- Don't write automatically.
-- vim.o.background = 'dark'        -- Use a dark background.
vim.o.backup = false                    -- Some servers have issues with backup files.
vim.o.clipboard = 'unnamedplus'         -- Use system CLIPBOARD for copy/cut/paste
vim.o.cmdheight = 2                     -- Give more space for commands and messages.
vim.o.colorcolumn = '100,120'           -- Highlight column 101 to give wrapping hints.
vim.o.concealcursor = ''                -- Don't conceal text on the current cursor line.
vim.o.conceallevel = 2                  -- Allow conceals to apply.
vim.o.confirm = true                    -- Create a confirm dialog when trying to to quit with unsaved changes.
vim.o.encoding = 'UTF-8'                -- Default encoding is UTF-8.
vim.o.expandtab = true                  -- Turn tabs into spaces.
vim.o.foldcolumn = 'auto:5'             -- Always set this to the same value as foldnestmax
vim.o.foldmethod = 'syntax'             -- Fold sections according to file syntax.
vim.o.foldnestmax = 5                   -- Don't fold more than 3 deep.
vim.o.gdefault = true                   -- Add g to replacements so it replaces all on line.
vim.o.hidden = true                     -- Hide buffer instead of failing when trying to open something over it when there are changes.
vim.o.hlsearch = true                   -- Highlight all search results from most recent search.
vim.o.inccommand = 'split'              -- Show previews of replacements before applying.
vim.o.incsearch = true                  -- Show match as search string is typed.
vim.o.lazyredraw = true                 -- Don't redraw in the middle of macros.
vim.o.mouse = 'a'                       -- Allow mouse in all modes.
vim.o.mousehide = true                  -- Hide mouse pointer when typing.
vim.o.mousemodel = 'popup_setpos'       -- Open a menu on right click.
vim.o.number = true                     -- Line Numbers.
vim.o.pumblend = 20                     -- Pseudo-transparency for popup menus. 80% opaque.
vim.o.pyxversion = 3                    -- Only allow using python3.
vim.o.relativenumber = false            -- No relative numbering.
vim.o.report = 0                        -- Report number of changed lines for most ':' commands.
vim.o.scroll = 5                        -- Lines to scroll with <C-U> and <C-D>.
vim.o.shiftwidth = 0                    -- Indent from normal mode equal to tabstop.
-- vim.o.shortmess:append('c')             -- Remove messages from in-completion menus.
vim.o.showbreak = '>>> '                -- Characters to put at the start of wrapped lines.
vim.o.softtabstop = 4                   -- Spaces to remove in insert.
vim.o.splitbelow = true                 -- Open splits to the bottom or right of active.
vim.o.splitright = true                 -- Open splits to the bottom or right of active.
vim.o.tabstop = 4                       -- Tab width.
vim.o.termguicolors = true              -- 24 Bit color.
vim.o.timeout = true                    -- Use timeoutlen to wait for keybindings to complete.
vim.o.timeoutlen = 2000                 -- Wait 2 seconds for keybindings to complete.
vim.o.undodir = '/home/devon/.vim/undo' -- Specify where to store undo histories.
vim.o.undofile = true                   -- Enable persisting undo stacks across sessions.
vim.o.updatetime = 100                  -- How many milliseconds to wait to write swap file after edits stopped.
vim.o.virtualedit = 'onemore'           -- go one char beyond in in normal mode.
vim.o.winblend = 10                     -- Floating windows at 90% opacity.
vim.o.wrap = false                      -- No line wrapping.
vim.o.writebackup = false               -- Some servers have issues with backup files.
-- vim.o.fillchars = {
--     vert = "│",
--     vertleft = "┤",
--     vertright = "├",
--     verthoriz = "┼",
--     horiz = "─",
--     horizup = "┴",
--     horizdown = "┬",
--     fold = "-",
--     eob = " ", -- suppress ~ at EndOfBuffer
--     diff = "⣿", -- alternatives = ⣿ ░ ─
--     msgsep = "‾",
--     foldopen = "▾",
--     foldsep = "│",
--     foldclose = "▸",
-- }

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'


----------------------------
-- CUSTOM COMMANDS
----------------------------
vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]]) -- Run formatting on wq.

vim.cmd([[
  " Kill a buffer and then close if only control windows are left.
  command! -nargs=0 -bang Qbuf bp<bang>|bw<bang> #|call CloseIfOnlyControlWinLeft()
  " Have q just wipe out a buffer and Q wipe out a split.
  cnoreabbr <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Qbuf' : 'q'
  cnoreabbr <expr> wq getcmdtype() == ":" && getcmdline() == 'wq' ? 'w<CR>:Qbuf' : 'wq'
  cnoreabbr <expr> Q getcmdtype() == ":" && getcmdline() == 'Q' ? '<C-w>q' : 'wq'
  autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
  function! SynStack()
    for i1 in synstack(line("."), col("."))
      let i2 = synIDtrans(i1)
      let n1 = synIDattr(i1, "name")
      let n2 = synIDattr(i2, "name")
      echo n1 "->" n2
    endfor
  endfunction
  function! CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
      \ || &buftype == 'quickfix' || (line('$') == 1 && getline(1) == '')
    qa
  endif
  endfunction
]])


----------------------------
-- HIGHLIGHT ON YANK
----------------------------
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


----------------------------
-- TELESCOPE
----------------------------
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})


local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end


----------------------------
-- TREESITTER
----------------------------
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)


----------------------------
-- LANGUAGE SERVER KEYBINDINGS
----------------------------
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('<C-h>', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

----------------------------
-- KEYBINDINGS
----------------------------
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })
vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { noremap = true, desc = 'Go to next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { noremap = true, desc = 'Go to previous buffer' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { noremap = true, desc = 'Exit to normal mode from terminal mode' })
vim.keymap.set('n', '<Left>', '<C-W>h', { noremap = true, desc = 'Move to the split to the left' })
vim.keymap.set('n', '<Down>', '<C-W>j', { noremap = true, desc = 'Move to the split to the bottom' })
vim.keymap.set('n', '<Up>', '<C-W>k', { noremap = true, desc = 'Move to the split to the top' })
vim.keymap.set('n', '<Right>', '<C-W>l', { noremap = true, desc = 'Move to the split to the right' })
vim.keymap.set('n', ';', ':', { desc = 'Go to command mode' })
vim.keymap.set('n', '$', '$l', { noremap = true, desc = 'Move to one column past the end of the line.' })
vim.keymap.set({ 'n', 'v' }, 'd', '"_d',
  { nowait = true, desc = 'Delete the current selection (or line if no selection) without copying it' })
require('which-key').register({
  ['<Leader>'] = {
    ['i'] = {
      ['a'] = { '<Cmd>TSLspImportAll<CR>', "Add any missing imports.", mode = 'n' },
      ['o'] = { '<Cmd>TSLspOrganize<CR>', "Sort existing imports.", mode = 'n' },
    },
    ['f'] = {
      ['r'] = { '<Cmd>TSLspRenameFile<CR>', "Do a refactor renaming the current file.", mode = 'n' },
    },
  },
  -- [')'] = { '^', ".", mode = 'nx' },
  ['c'] = {
    -- ['f'] = { vim.lsp.buf.formatting, "Format the current buffer.", mode = 'n' },
    ['r'] = { vim.lsp.buf.rename, "Rename all references to the currently selected symbol.", mode = 'n' },
    -- ['n'] = {
    --     ['s'] = { possession.new, "Create a new session.", mode = "n" },
    -- },
  },
  ['g'] = {
    -- { '(', 'g^', mode = 'nx' },
    ['b'] = { '<C-O>', "Jump backwards in the jump list.", mode = 'n' },
    ['d'] = { vim.lsp.buf.definition, "Go to the definition of the symbol under the cursor.", mode = 'n' },
    ['D'] = { vim.lsp.buf.declaration, "Go to the declaration of the symbol under the cursor.", mode = 'n' },
    ['e'] = { vim.diagnostic.goto_next, "Go to the next error.", mode = 'n' },
    ['E'] = { vim.diagnostic.goto_prev, "Go to the previous error.", mode = 'n' },
    ['f'] = { '<C-I>', "Jump forwards in the jump list.", mode = 'n' },
    ['i'] = { vim.lsp.buf.implementation, "Go to the implementation of the symbol under the cursor.", mode = 'n' },
    ['q'] = {
      ['N'] = { '<Cmd>cprev<CR>', "Go to the previous error in the quickfix list.", mode = 'n' },
      ['n'] = { '<Cmd>cnext<CR>', "Go to the next error in the quickfix list.", mode = 'n' },
    },
    ['t'] = {
      ['d'] = {
        vim.lsp.buf.type_definition,
        "Go to the type definition of the symbol under the cursor.",
        mode = 'n'
      },
    },
  },
  ['h'] = { '<BS>', 'Move one column to the left with line wrapping.', mode = 'n' },
  ['H'] = { '5zh5h', "Scroll 5 columns to the left without moving the cursor relative to the screen.", mode = 'n' },
  ['<C-H>'] = { vim.lsp.buf.hover, "Show hover information.", mode = 'n' },
  ['J'] = { '5<Plug>(SmoothieDownwards)', "Scroll smoothly downwards 5 lines.", mode = 'n', noremap = false },
  ['K'] = { '5<Plug>(SmoothieUpwards)', "Scroll smoothly upwards 5 lines.", mode = 'n', noremap = false },
  ['L'] = { '5zl5l', "Scroll 5 columns right without moving the cursor relative to the screen.", mode = 'n' },
  ['l'] = { '<Space>', 'Move one character to the right with line wrapping.', mode = 'n' },
  ['m'] = {
    ['s'] = {
      ['e'] = { '<C-W>=', "Make all splits the same size.", mode = 'n' },
      ['h'] = { '<Cmd>split<CR>', "Make a new horizontal split.", mode = 'n' },
      ['v'] = { '<Cmd>vsplit<CR>', "Make a new vertical split.", mode = 'n' },
    },
  },
  ['<C-N>'] = { '<Cmd>enew<CR>', "Open a blank new buffer.", mode = 'n' },
  ['p'] = { '"_dP', "Paste from the system clipboard.", mode = 'x' },
  ['q'] = { '<Nop>', '', mode = 'n' },
  ['<C-R>'] = {
    ['h'] = {
      '<Cmd>call animate#window_delta_height(5)<CR>',
      "Smoothly increase the current windows height by 5 rows.",
      mode = 'n'
    },
    ['H'] = {
      '<Cmd>call animate#window_delta_height(-5)<CR>',
      "Smoothly decrease the current windows height by 5 rows.",
      mode = 'n'
    },
    ['w'] = {
      '<Cmd>call animate#window_delta_width(5)<CR>',
      "Smoothly increase the current windows width by 5 columns.",
      mode = 'n'
    },
    ['W'] = {
      '<Cmd>call animate#window_delta_width(-5)<CR>',
      "Smoothly decrease the current windows height by 5 columns.",
      mode = 'n'
    },
  },
  ['s'] = {
    ['c'] = {
      ['a'] = { vim.lsp.buf.code_action, "Show available code actions at this position.", mode = 'n' },
    },
    ['e'] = { vim.diagnostic.open_float, "Show diagnostics in a new float.", mode = 'n' },
    ['h'] = {
      ['g'] = { '<Cmd>call SynStack()<CR>', "Show the highlight group stack at the current position.", mode = 'n' },
    },
    ['j'] = { '<Cmd>jumps<CR>', "Show the jump list.", mode = 'n' },
    ['m'] = { '<Cmd>marks<CR>', "Show all marks.", mode = 'n' },
    ['r'] = {
      '<Cmd>TroubleToggle lsp_references<CR>',
      "Toggle showing all references to the symbol under the cursor.",
      mode = 'n'
    },
  },
  ['t'] = {
    ['d'] = {
      ['d'] = {
        '<Cmd>TroubleToggle document_diagnostics<CR>',
        "Toggle showing a window with the diagnostics for the current document.",
        mode = 'n'
      },
      ['w'] = {
        '<Cmd>TroubleToggle workspace_diagnostics<CR>',
        "Toggle showing a window with all the diagnostics for the current workspace.",
        mode = 'n'
      },
    },
    ['l'] = {
      ['l'] = { '<Cmd>TroubleToggle loclist<CR>', "Toggle showing a window with the location list.", mode = 'n' },
    },
    ['m'] = {
      ['p'] = { '<Plug>MarkdownPreviewToggle', 'Toggle a live markdown live preview in the browser.', mode = 'n' },
    },
    ['q'] = {
      '<Cmd>TroubleToggle quickfix<CR>',
      "Toggle showing a window with the current quickfix list.",
      mode = 'n'
    },
    ['r'] = {
      '<Cmd>TroubleToggle lsp_references<CR>',
      "Toggle showing all references to the symbol under the cursor.",
      mode = 'n'
    },
    ['s'] = {
      '<Cmd>SymbolsOutline<CR>',
      'Toggle showing a tree based outline of all symbols in the current buffer.',
      mode = 'n'
    },
    ['t'] = { '<Cmd>TroubleToggle<CR>', "Toggle showing the trouble(list) window.", mode = 'n' },
    ['u'] = {
      ['h'] = { '<Cmd>MundoToggle<CR>', "Toggle showing the undo history tree.", mode = 'n' },
    },
  },
  ['U'] = { '<C-R>', "Redo the last action.", mode = 'n' },
  ['x'] = { '"_x', "Delete the character under the cursor.", mode = 'n' },
})



----------------------------
-- LANGUAGE SERVERS
----------------------------
--[[ ------------------------------------- ]]
--[[ Handling mason is covered in the help ]]
--[[ See :help nixCats.luaUtils.mason      ]]
--[[ ------------------------------------- ]]
-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
-- if not require('nixCatsUtils').isNixCats then
--   require('mason').setup()
--   require('mason-lspconfig').setup()
-- end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  nixd = {}, -- requires nixd (pkgs.nixd)
  nil_ls = {}, -- requires nil (pkgs.nil)

  lua_ls = { -- requires lua-language-server (pkgs.lua-language-server)
    Lua = {
      formatters = {
        ignoreComments = true,
      },
      signatureHelp = { enabled = true },
    },
    workspace = { checkThirdParty = true },
    telemetry = { enabled = false },
    filetypes = { 'lua' },
  },

  bashls = {}, -- requires bash-language-server (nodePackages.bash-language-server)

  diagnosticls = { -- requires diagnostic-languageserver (nodePackages.diagnostic-languageserver)
    -- and configuration of whatever diagnostic tools it's used with.
    filetypes = { "python" },
    init_options = {
      linters = {
        flake8 = {
          command = vim.fn.exepath('flake8'),
          args = { [[--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s]], '-' },
          debounce = 100,
          offsetLine = 0,
          offsetColumn = 0,
          formatLines = 1,
          formatPattern = {
            [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
            { line = 1, column = 2, security = 3, message = { '[flake8] ', 4 } },
          },
          securities = {
            W = 'warning',
            E = 'error',
            F = 'error',
            C = 'error',
            N = 'error',
          },
        },
      },
      formatters = {
        black = {
          command = vim.fn.exepath("black"),
          args = { "--quiet", "-" },
          rootPatterns = {
            '.git',
            'pyproject.toml',
          },
        },
        isort = {
          command = vim.fn.exepath("isort"),
          args = { '--quiet', '--stdout', '-' },
          rootPatterns = {
            '.git',
            'pyproject.toml',
          },
        },
      },
      formatFiletypes = {
          python = { "black", "isort" },
      },
    },
    format = true,
    -- root_dir = lsp.util.root_pattern('.git'),
  },

  eslint = { -- requires vscode-eslint-language-server (not available individually so needs nodePackages.vscode-langservers-extracted)
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
                  "typescript.tsx", "vue" },
    settings = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = true,
        mode = "all",
      },
      format = true,
      onIgnoredFiles = "off",
      packageManager = "npm",
      problems = {
        shortenToSingleLine = false,
      },
      quiet = true,
      run = "onType",
      validate = "on",
    },
  },

  pyright = { -- requires pyright (nodePackages.pyright)
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },

  tsserver = { -- requires typescript-language-server (nodePackages.typescript-language-server)
    init_options = {
        hostInfo = "neovim",
    },
  },
}

-- Setup neovim lua configuration
-- require('neodev').setup()

-- require("neoconf").setup({
--   plugins = {
--     lua_ls = {
--       enabled = true,
--       enabled_for_neovim_config = true,
--     },
--   },
-- })
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

--[[ ------------------------------------- ]]
--[[ Handling mason is covered in the help ]]
--[[ See :help nixCats.luaUtils.mason      ]]
--[[ ------------------------------------- ]]
if isNix then
  -- for server_name, _ in pairs(servers) do
  --   require('lspconfig')[server_name].setup({
  --     capabilities = capabilities,
  --     on_attach = on_attach,
  --     settings = servers[server_name],
  --     filetypes = (servers[server_name] or {}).filetypes,
  --     cmd = (servers[server_name] or {}).cmd,
  --     root_pattern = (servers[server_name] or {}).root_pattern,
  --   })
  -- end
else
  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end,
  }
end
--[[ ------------------------------------- ]]
--[[ Handling mason is covered in the help ]]
--[[ See :help nixCats.luaUtils.mason      ]]
--[[ ------------------------------------- ]]


----------------------------
-- NVIM CMP
----------------------------
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
