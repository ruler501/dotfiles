local set = vim.opt

set.autochdir = false                 -- Don't change directories automatically.
set.autoread = true                   -- Auto reload if no changes in buffer.
set.autowrite = false                 -- Don't write automatically.
-- set.background = 'dark'        -- Use a dark background.
set.backup = false                    -- Some servers have issues with backup files.
set.clipboard = 'unnamedplus'         -- Use system CLIPBOARD for copy/cut/paste
set.cmdheight = 2                     -- Give more space for commands and messages.
set.colorcolumn = '100,120'           -- Highlight column 101 to give wrapping hints.
set.concealcursor = ''                -- Don't conceal text on the current cursor line.
set.conceallevel = 2                  -- Allow conceals to apply.
set.confirm = true                    -- Create a confirm dialog when trying to to quit with unsaved changes.
set.encoding = 'UTF-8'                -- Default encoding is UTF-8.
set.expandtab = true                  -- Turn tabs into spaces.
set.foldcolumn = 'auto:5'             -- Always set this to the same value as foldnestmax
set.foldmethod = 'syntax'             -- Fold sections according to file syntax.
set.foldnestmax = 5                   -- Don't fold more than 3 deep.
set.gdefault = true                   -- Add g to replacements so it replaces all on line.
set.hidden = true                     -- Hide buffer instead of failing when trying to open something over it when there are changes.
set.hlsearch = true                   -- Highlight all search results from most recent search.
set.inccommand = 'split'              -- Show previews of replacements before applying.
set.incsearch = true                  -- Show match as search string is typed.
set.lazyredraw = true                 -- Don't redraw in the middle of macros.
set.mouse = 'a'                       -- Allow mouse in all modes.
set.mousehide = true                  -- Hide mouse pointer when typing.
set.mousemodel = 'popup_setpos'       -- Open a menu on right click.
set.number = true                     -- Line Numbers.
set.pumblend = 20                     -- Pseudo-transparency for popup menus. 80% opaque.
set.pyxversion = 3                    -- Only allow using python3.
set.relativenumber = false            -- No relative numbering.
set.report = 0                        -- Report number of changed lines for most ':' commands.
set.scroll = 5                        -- Lines to scroll with <C-U> and <C-D>.
set.shiftwidth = 0                    -- Indent from normal mode equal to tabstop.
set.shortmess:append('c')             -- Remove messages from in-completion menus.
set.showbreak = '>>> '                -- Characters to put at the start of wrapped lines.
set.softtabstop = 4                   -- Spaces to remove in insert.
set.splitbelow = true                 -- Open splits to the bottom or right of active.
set.splitright = true                 -- Open splits to the bottom or right of active.
set.tabstop = 4                       -- Tab width.
set.termguicolors = true              -- 24 Bit color.
set.timeout = true                    -- Use timeoutlen to wait for keybindings to complete.
set.timeoutlen = 2000                 -- Wait 2 seconds for keybindings to complete.
set.undodir = '/home/devon/.vim/undo' -- Specify where to store undo histories.
set.undofile = true                   -- Enable persisting undo stacks across sessions.
set.updatetime = 100                  -- How many milliseconds to wait to write swap file after edits stopped.
set.virtualedit = 'onemore'           -- go one char beyond in in normal mode.
set.winblend = 10                     -- Floating windows at 90% opacity.
set.wrap = false                      -- No line wrapping.
set.writebackup = false               -- Some servers have issues with backup files.
set.fillchars = {
    vert = "│",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    fold = "-",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "⣿", -- alternatives = ⣿ ░ ─
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}
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

vim.g.mapleader = ","

-- Non-Printable characters sorted by javascript key code of leading character
-- excluding modifier such as Ctrl, Alt, Shift. Otherwise by ascii
-- See https://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
-- and http://www.asciitable.com/
-- <BS>/<C-H>, <TAB>/<C-I>, <CR>/<C-M>, <ESC>/<C-[>, <PageUp>, <PageDown>, <End>, <Home>, <Left>, <Up>,
-- <Right>, <Down>, <Insert>, <Del>, <Space>, !, ", #, $, %, &, ', (, ), *, +, ,,
-- -, ., /, :, ;, <, >, =, ?, @, [, ], \, ^, _, `, {, },<bar>/|,  ~, [0-9], [a-z]
-- For modifiers list in order of
-- - None
-- - Shift
-- - Ctrl
-- - Shift-Ctrl
-- - Alt/M
-- - Shift-Alt
-- - Ctrl-Alt
-- - Shift-Ctrl-Alt
-- Exceptions on orders are made for commands in a block doing the same type of
-- thing. Leader is sorted as comma.
--
-- You cannot map Ctrl-Shift-[a-z] different from Ctrl-[a-z] since they send
-- the same keycodes.
--
local wk = require("which-key")
wk.setup()
require("legendary").setup({
    -- Initial keymaps to bind
    keymaps = {},
    -- Initial commands to bind
    commands = {},
    -- Initial augroups/autocmds to bind
    autocmds = {},
    -- Initial functions to bind
    funcs = {},
    -- Initial item groups to bind,
    -- note that item groups can also
    -- be under keymaps, commands, autocmds, or funcs
    itemgroups = {},
    -- default opts to merge with the `opts` table
    -- of each individual item
    default_opts = {
        keymaps = {},
        commands = {},
        autocmds = {},
    },
    -- Customize the prompt that appears on your vim.ui.select() handler
    -- Can be a string or a function that returns a string.
    select_prompt = ' legendary.nvim ',
    -- Character to use to separate columns in the UI
    col_separator_char = '│',
    -- Optionally pass a custom formatter function. This function
    -- receives the item as a parameter and the mode that legendary
    -- was triggered from (e.g. `function(item, mode): string[]`)
    -- and must return a table of non-nil string values for display.
    -- It must return the same number of values for each item to work correctly.
    -- The values will be used as column values when formatted.
    -- See function `default_format(item)` in
    -- `lua/legendary/ui/format.lua` to see default implementation.
    default_item_formatter = nil,
    -- Include builtins by default, set to false to disable
    include_builtin = true,
    -- Include the commands that legendary.nvim creates itself
    -- in The Legend by default, set to false to disable
    include_legendary_cmds = true,
    -- Options for list sorting. Note that fuzzy-finders will still
    -- do their own sorting.
    sort = {
        -- sort most recently used item to the top
        most_recent_first = true,
        -- sort user-defined items before built-in items
        user_items_first = true,
        -- sort the specified item type before other item types,
        -- value must be one of: 'keymap', 'command', 'autocmd', 'group', nil
        item_type_bias = nil,
        -- settings for frecency sorting.
        -- https://en.wikipedia.org/wiki/Frecency
        -- Set `frecency = false` to disable.
        -- this feature requires sqlite.lua (https://github.com/tami5/sqlite.lua)
        -- and will be automatically disabled if sqlite is not available.
        -- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
        frecency = {
            -- the directory to store the database in
            db_root = string.format('%s/legendary/', vim.fn.stdpath('data')),
            -- the maximum number of timestamps for a single item
            -- to store in the database
            max_timestamps = 10,
        },
    },
    extensions = {
        which_key = {
            -- Automatically add which-key tables to legendary
            -- see ./doc/WHICH_KEY.md for more details
            auto_register = true,
            -- you can put which-key.nvim tables here,
            -- or alternatively have them auto-register,
            -- see ./doc/WHICH_KEY.md
            mappings = {},
            opts = {},
            -- controls whether legendary.nvim actually binds they keymaps,
            -- or if you want to let which-key.nvim handle the bindings.
            -- if not passed, true by default
            do_binding = true,
        },
    },
    scratchpad = {
        -- How to open the scratchpad buffer,
        -- 'current' for current window, 'float'
        -- for floating window
        view = 'float',
        -- How to show the results of evaluated Lua code.
        -- 'print' for `print(result)`, 'float' for a floating window.
        results_view = 'float',
        -- Border style for floating windows related to the scratchpad
        float_border = 'rounded',
        -- Whether to restore scratchpad contents from a cache file
        keep_contents = true,
    },
    -- Directory used for caches
    cache_path = string.format('%s/legendary/', vim.fn.stdpath('cache')),
    -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
    log_level = 'info',
})

wk.register({
    ['<Tab>'] = { '<Cmd>bnext<CR>', "Go to next buffer.", mode = 'n' },
    ['<S-Tab>'] = { '<Cmd>bprevious<CR>', "Go to previous buffer.", mode = 'n' },
    ['<Esc>'] = { '<C-\\><C-N>', "Exit to normal mode from terminal mode.", mode = 't' },
    ['<Left>'] = { '<C-W>h', "Move to the split to the left.", mode = 'n' },
    ['<Down>'] = { '<C-W>j', "Move to the split below.", mode = 'n' },
    ['<Up>'] = { '<C-W>k', "Move to the split above.", mode = 'n' },
    ['<Right>'] = { '<C-W>l', "Move to the split to the right.", mode = 'n' },
    ['<Leader>'] = {
        ['i'] = {
            ['a'] = { '<Cmd>TSLspImportAll<CR>', "Add any missing imports.", mode = 'n' },
            ['o'] = { '<Cmd>TSLspOrganize<CR>', "Sort existing imports.", mode = 'n' },
        },
        ['f'] = {
            ['r'] = { '<Cmd>TSLspRenameFile<CR>', "Do a refactor renaming the current file.", mode = 'n' },
        },
    },
    [';'] = { ':', "Go to command mode.", mode = 'n', silent = false },
    -- [')'] = { '^', ".", mode = 'nx' },
    ['$'] = { '$l', "Move one character past the end of the line.", mode = 'n' },
    ['c'] = {
        ['f'] = { vim.lsp.buf.formatting, "Format the current buffer.", mode = 'n' },
        ['r'] = { vim.lsp.buf.rename, "Rename all references to the currently selected symbol.", mode = 'n' },
        -- ['n'] = {
        --     ['s'] = { possession.new, "Create a new session.", mode = "n" },
        -- },
    },
    ['d'] = { '"_d', 'Delete without copying the text.', mode = 'n', nowait = true },
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
            ['d'] = { vim.lsp.buf.type_definition, "Go to the type definition of the symbol under the cursor.",
                mode = 'n' },
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
        ['h'] = { '<Cmd>call animate#window_delta_height(5)<CR>',
            "Smoothly increase the current windows height by 5 rows.", mode = 'n' },
        ['H'] = { '<Cmd>call animate#window_delta_height(-5)<CR>',
            "Smoothly decrease the current windows height by 5 rows.", mode = 'n' },
        ['w'] = { '<Cmd>call animate#window_delta_width(5)<CR>',
            "Smoothly increase the current windows width by 5 columns.", mode = 'n' },
        ['W'] = { '<Cmd>call animate#window_delta_width(-5)<CR>',
            "Smoothly decrease the current windows height by 5 columns.", mode = 'n' },
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
        ['r'] = { '<Cmd>TroubleToggle lsp_references<CR>',
            "Toggle showing all references to the symbol under the cursor.", mode = 'n' },
    },
    ['t'] = {
        ['d'] = {
            ['d'] = { '<Cmd>TroubleToggle document_diagnostics<CR>',
                "Toggle showing a window with the diagnostics for the current document.", mode = 'n' },
            ['w'] = { '<Cmd>TroubleToggle workspace_diagnostics<CR>',
                "Toggle showing a window with all the diagnostics for the current workspace.", mode = 'n' },
        },
        ['l'] = {
            ['l'] = { '<Cmd>TroubleToggle loclist<CR>', "Toggle showing a window with the location list.", mode = 'n' },
        },
        ['m'] = {
            ['p'] = { '<Plug>MarkdownPreviewToggle', 'Toggle a live markdown live preview in the browser.', mode = 'n' },
        },
        ['q'] = { '<Cmd>TroubleToggle quickfix<CR>', "Toggle showing a window with the current quickfix list.",
            mode = 'n' },
        ['r'] = { '<Cmd>TroubleToggle lsp_references<CR>',
            "Toggle showing all references to the symbol under the cursor.", mode = 'n' },
        ['s'] = { '<Cmd>SymbolsOutline<CR>', 'Toggle showing a tree based outline of all symbols in the current buffer.',
            mode = 'n' },
        ['t'] = { '<Cmd>TroubleToggle<CR>', "Toggle showing the trouble(list) window.", mode = 'n' },
        ['u'] = {
            ['h'] = { '<Cmd>MundoToggle<CR>', "Toggle showing the undo history tree.", mode = 'n' },
        },
    },
    ['U'] = { '<C-R>', "Redo the last action.", mode = 'n' },
    ['x'] = { '"_x', "Delete the character under the cursor.", mode = 'n' },
})
wk.register({
    ['<Tab>'] = { '>gv', "Increase indent of selected text.", mode = 'v' },
    ['<S-Tab>'] = { '<gv', "Decrease indent of selected text.", mode = 'v' },
    ['$'] = { '$h', "Move to the last character of the line.", mode = 'v' },
    [';'] = { ':', "Go to command mode.", mode = 'v', silent = false },
    ['d'] = { '"_d', 'Delete without copying the text.', mode = 'v', nowait = true },
    ['h'] = { '<BS>', 'Move one column to the left with line wrapping.', mode = 'v' },
    ['H'] = { '5zh5h', "Scroll 5 columns to the left without moving the cursor relative to the screen.", mode = 'v' },
    ['<C-H>'] = { vim.lsp.buf.hover, "Show hover information.", mode = 'x' },
    ['l'] = { '<Space>', 'Move one character to the right with line wrapping.', mode = 'v' },
    ['L'] = { '5zl5l', "Scroll 5 columns right without moving the cursor relative to the screen.", mode = 'v' },
    ['J'] = { '5<C-E>5j', "Scroll 5 rows down without moving the cursor relative to the screen.", mode = 'v' },
    ['K'] = { '5<C-Y>5k', "Scroll 5 rows up without moving the cursor relative to the screen.", mode = 'v' },
    ['<C-R>'] = { '<Nop>', '', mode = 'n' },
    ['s'] = { '<Nop>', '', mode = 'n' },
    ['m'] = {
        ['s'] = {
            ['e'] = { '<C-W>=', "Make all splits the same size.", mode = 'v' },
            ['h'] = { '<Cmd>split<CR>', "Make a new horizontal split.", mode = 'v' },
            ['v'] = { '<Cmd>vsplit<CR>', "Make a new vertical split.", mode = 'v' },
        },
    },
    ['<C-P>'] = { '<Cmd>Legendary<CR>', '', mode = { 'n', 'x', 'i' }, silent = true, noremap = true, nowait = true },
})

require('dressing').setup({
    input = {
        -- Set to false to disable the vim.ui.input implementation
        enabled = true,
        -- Default prompt string
        default_prompt = "Input:",
        -- Can be 'left', 'right', or 'center'
        prompt_align = "left",
        -- When true, <Esc> will close the modal
        insert_only = true,
        -- When true, input will start in insert mode.
        start_in_insert = true,
        border = "rounded",
        -- 'editor' and 'win' will default to being centered
        relative = "cursor",
        -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        prefer_width = 40,
        width = nil,
        -- min_width and max_width can be a list of mixed types.
        -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        buf_options = {},
        win_options = {
            -- Window transparency (0-100)
            winblend = 10,
            -- Disable line wrapping
            wrap = false,
        },
        -- Set to `false` to disable
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },
        override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
        end,
        -- see :help dressing_get_config
        get_config = function(opts)
            if opts.kind == 'legendary.nvim' then
                return {
                    telescope = {
                        sorter = require('telescope.sorters').fuzzy_with_index_bias({})
                    }
                }
            else
                return {}
            end
        end
    },
    select = {
        -- Set to false to disable the vim.ui.select implementation
        enabled = true,
        -- Priority list of preferred vim.select implementations
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
        -- Trim trailing `:` from prompt
        trim_prompt = true,
        -- Options for telescope selector
        -- These are passed into the telescope picker directly. Can be used like:
        -- telescope = require('telescope.themes').get_ivy({...})
        telescope = nil,
        -- Options for fzf selector
        fzf = {
            window = {
                width = 0.5,
                height = 0.4,
            },
        },
        -- Options for fzf_lua selector
        fzf_lua = {
            winopts = {
                width = 0.5,
                height = 0.4,
            },
        },
        -- Options for nui Menu
        nui = {
            position = "50%",
            size = nil,
            relative = "editor",
            border = {
                style = "rounded",
            },
            buf_options = {
                swapfile = false,
                filetype = "DressingSelect",
            },
            win_options = {
                winblend = 10,
            },
            max_width = 80,
            max_height = 40,
            min_width = 40,
            min_height = 10,
        },
        -- Options for built-in selector
        builtin = {
            -- These are passed to nvim_open_win
            anchor = "NW",
            border = "rounded",
            -- 'editor' and 'win' will default to being centered
            relative = "editor",
            buf_options = {},
            win_options = {
                -- Window transparency (0-100)
                winblend = 10,
            },
            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- the min_ and max_ options can be a list of mixed types.
            -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
            width = nil,
            max_width = { 140, 0.8 },
            min_width = { 40, 0.2 },
            height = nil,
            max_height = 0.9,
            min_height = { 10, 0.2 },
            -- Set to `false` to disable
            mappings = {
                ["<Esc>"] = "Close",
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            override = function(conf)
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                return conf
            end,
        },
        -- Used to override format_item. See :help dressing-format
        format_item_override = {},
        -- see :help dressing_get_config
        get_config = nil,
    },
})

require('nvim-web-devicons').setup {
    default = true,
}

local actions = require("diffview.actions")

require("diffview").setup({
    diff_binaries = false,   -- Show diffs for binaries
    enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
    git_cmd = { "git" },     -- The git executable followed by default args.
    use_icons = true,        -- Requires nvim-web-devicons
    show_help_hints = true,  -- Show hints for how to open the help panel
    watch_index = true,      -- Update views and index buffers when the git index changes.
    icons = {
        -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
    },
    signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
    },
    view = {
        -- Configure the layout and behavior of different types of views.
        -- Available layouts:
        --  'diff1_plain'
        --  |'diff2_horizontal'
        --  |'diff2_vertical'
        --  |'diff3_horizontal'
        --  |'diff3_vertical'
        --  |'diff3_mixed'
        --  |'diff4_mixed'
        -- For more info, see ':h diffview-config-view.x.layout'.
        default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
        },
        merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff4_mixed",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
        },
        file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
        },
    },
    file_panel = {
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = {
            -- Only applies when listing_style is 'tree'
            flatten_dirs = true,        -- Flatten dirs that only contain one single dir
            folder_statuses = "always", -- One of 'never', 'only_folded' or 'always'.
        },
        win_config = {
            -- See ':h diffview-config-win_config'
            type = "split",
            position = "left",
            relative = "editor",
            width = 35,
            win_opts = {},
        },
    },
    file_history_panel = {
        log_options = {
            -- See ':h diffview-config-log_options'
            git = {
                single_file = {
                    diff_merges = "combined",
                },
                multi_file = {
                    diff_merges = "combined",
                },
            },
        },
        win_config = {
            -- See ':h diffview-config-win_config'
            type = "split",
            position = "bottom",
            relative = "editor",
            height = 20,
            win_opts = {}
        },
    },
    commit_log_panel = {
        win_config = { -- See ':h diffview-config-win_config'
            win_opts = {},
        }
    },
    default_args = {
        -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },
    hooks = {},                   -- See ':h diffview-config-hooks'
    keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            { "n", "<tab>",   actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "gf", actions.goto_file, {
                desc =
                "Open the file in a new split in the previous tabpage"
            } },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",    actions.goto_file_tab,   { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",  actions.focus_files,     { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",  actions.toggle_files,    { desc = "Toggle the file panel." } },
            { "n", "g<C-x>",     actions.cycle_layout,    { desc = "Cycle through available layouts." } },
            { "n", "[x", actions.prev_conflict, {
                desc =
                "In the merge-tool: jump to the previous conflict"
            } },
            { "n", "]x", actions.next_conflict, {
                desc =
                "In the merge-tool: jump to the next conflict"
            } },
            { "n", "<leader>co", actions.conflict_choose("ours"),   { desc = "Choose the OURS version of a conflict" } },
            { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" } },
            { "n", "<leader>cb", actions.conflict_choose("base"),   { desc = "Choose the BASE version of a conflict" } },
            { "n", "<leader>ca", actions.conflict_choose("all"),    { desc = "Choose all the versions of a conflict" } },
            { "n", "dx",         actions.conflict_choose("none"),   { desc = "Delete the conflict region" } },
        },
        diff1 = {
            -- Mappings in single window diff layouts
            { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
        },
        diff2 = {
            -- Mappings in 2-way diff layouts
            { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
        },
        diff3 = {
            -- Mappings in 3-way diff layouts
            { { "n",                                                          "x" }, "2do", actions.diffget("ours"),
                { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n",                                                            "x" }, "3do", actions.diffget("theirs"),
                { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n", "g?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
        },
        diff4 = {
            -- Mappings in 4-way diff layouts
            { { "n",                                                          "x" }, "1do", actions.diffget("base"),
                { desc = "Obtain the diff hunk from the BASE version of the file" } },
            { { "n",                                                          "x" }, "2do", actions.diffget("ours"),
                { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n",                                                            "x" }, "3do", actions.diffget("theirs"),
                { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n", "g?", actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
        },
        file_panel = {
            { "n", "j",             actions.next_entry,         { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>",        actions.next_entry,         { desc = "Bring the cursor to the next file entry" } },
            { "n", "k",             actions.prev_entry,         { desc = "Bring the cursor to the previous file entry." } },
            { "n", "<up>",          actions.prev_entry,         { desc = "Bring the cursor to the previous file entry." } },
            { "n", "<cr>",          actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "o",             actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "<2-LeftMouse>", actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "-",             actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
            { "n", "S",             actions.stage_all,          { desc = "Stage all entries." } },
            { "n", "U",             actions.unstage_all,        { desc = "Unstage all entries." } },
            { "n", "X",             actions.restore_entry,      { desc = "Restore entry to the state on the left side." } },
            { "n", "L",             actions.open_commit_log,    { desc = "Open the commit log panel." } },
            { "n", "<c-b>",         actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>",         actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
            { "n", "<tab>",         actions.select_next_entry,  { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",       actions.select_prev_entry,  { desc = "Open the diff for the previous file" } },
            { "n", "gf", actions.goto_file, {
                desc =
                "Open the file in a new split in the previous tabpage"
            } },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",    actions.goto_file_tab,   { desc = "Open the file in a new tabpage" } },
            { "n", "i",          actions.listing_style,   { desc = "Toggle between 'list' and 'tree' views" } },
            { "n", "f", actions.toggle_flatten_dirs,
                {
                    desc =
                    "Flatten empty subdirectories in tree listing style."
                } },
            { "n", "R",         actions.refresh_files,      { desc = "Update stats and entries in the file list." } },
            { "n", "<leader>e", actions.focus_files,        { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", actions.toggle_files,       { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",    actions.cycle_layout,       { desc = "Cycle available layouts" } },
            { "n", "[x",        actions.prev_conflict,      { desc = "Go to the previous conflict" } },
            { "n", "]x",        actions.next_conflict,      { desc = "Go to the next conflict" } },
            { "n", "g?",        actions.help("file_panel"), { desc = "Open the help panel" } },
        },
        file_history_panel = {
            { "n", "g!", actions.options,         { desc = "Open the option panel" } },
            { "n", "<C-A-d>", actions.open_in_diffview, {
                desc =
                "Open the entry under the cursor in a diffview"
            } },
            { "n", "y", actions.copy_hash, {
                desc =
                "Copy the commit hash of the entry under the cursor"
            } },
            { "n", "L",  actions.open_commit_log, { desc = "Show commit details" } },
            { "n", "zR", actions.open_all_folds,  { desc = "Expand all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
            { "n", "j", actions.next_entry, {
                desc =
                "Bring the cursor to the next file entry"
            } },
            { "n", "<down>", actions.next_entry, {
                desc =
                "Bring the cursor to the next file entry"
            } },
            { "n", "k", actions.prev_entry, {
                desc =
                "Bring the cursor to the previous file entry."
            } },
            { "n", "<up>", actions.prev_entry, {
                desc =
                "Bring the cursor to the previous file entry."
            } },
            { "n", "<cr>",          actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "o",             actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "<2-LeftMouse>", actions.select_entry,       { desc = "Open the diff for the selected entry." } },
            { "n", "<c-b>",         actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>",         actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
            { "n", "<tab>",         actions.select_next_entry,  { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",       actions.select_prev_entry,  { desc = "Open the diff for the previous file" } },
            { "n", "gf", actions.goto_file, {
                desc =
                "Open the file in a new split in the previous tabpage"
            } },
            { "n", "<C-w><C-f>", actions.goto_file_split,            { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",    actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",  actions.focus_files,                { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",  actions.toggle_files,               { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",     actions.cycle_layout,               { desc = "Cycle available layouts" } },
            { "n", "g?",         actions.help("file_history_panel"), { desc = "Open the help panel" } },
        },
        option_panel = {
            { "n", "<tab>", actions.select_entry,         { desc = "Change the current option" } },
            { "n", "q",     actions.close,                { desc = "Close the panel" } },
            { "n", "g?",    actions.help("option_panel"), { desc = "Open the help panel" } },
        },
        help_panel = {
            { "n", "q",     actions.close, { desc = "Close help menu" } },
            { "n", "<esc>", actions.close, { desc = "Close help menu" } },
        },
    },
})

local cmp = require "cmp"
local cmp_buffer = require "cmp_buffer"

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local snippy = require('snippy')

snippy.setup({})

cmp.setup({
    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-Space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'latex_symbols' },
        { name = 'treesitter' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'snippy' },
    },
    sorting = {
        comparators = {
            function(...) return cmp_buffer:compare_locality(...) end,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lsp-format").setup {}

local on_attach = function(client)
    require("lsp-format").on_attach(client)
end

require("symbols-outline").setup({
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = 'right',
    relative_width = true,
    width = 25,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    autofold_depth = nil,
    auto_unfold_hover = true,
    fold_markers = { '', '' },
    wrap = false,
    keymaps = {
        -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        -- toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
        File = { icon = "", hl = "TSURI" },
        Module = { icon = "", hl = "TSNamespace" },
        Namespace = { icon = "", hl = "TSNamespace" },
        Package = { icon = "", hl = "TSNamespace" },
        Class = { icon = "𝓒", hl = "TSType" },
        Method = { icon = "ƒ", hl = "TSMethod" },
        Property = { icon = "", hl = "TSMethod" },
        Field = { icon = "", hl = "TSField" },
        Constructor = { icon = "", hl = "TSConstructor" },
        Enum = { icon = "ℰ", hl = "TSType" },
        Interface = { icon = "ﰮ", hl = "TSType" },
        Function = { icon = "", hl = "TSFunction" },
        Variable = { icon = "", hl = "TSConstant" },
        Constant = { icon = "", hl = "TSConstant" },
        String = { icon = "𝓐", hl = "TSString" },
        Number = { icon = "#", hl = "TSNumber" },
        Boolean = { icon = "⊨", hl = "TSBoolean" },
        Array = { icon = "", hl = "TSConstant" },
        Object = { icon = "⦿", hl = "TSType" },
        Key = { icon = "🔐", hl = "TSType" },
        Null = { icon = "NULL", hl = "TSType" },
        EnumMember = { icon = "", hl = "TSField" },
        Struct = { icon = "𝓢", hl = "TSType" },
        Event = { icon = "🗲", hl = "TSType" },
        Operator = { icon = "+", hl = "TSOperator" },
        TypeParameter = { icon = "𝙏", hl = "TSParameter" }
    }
})

local lsp = require "lspconfig"

lsp.bashls.setup { -- requires bash-language-server (nodePackages.bash-language-server)
    capabilities = capabilities,
    on_attach = on_attach,
}
lsp.ccls.setup { -- requires ccls and clang (pkgs.ccls and pkgs.clang_14 version will need updating periodically)
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        compilationDatabaseDirectory = "build",
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { "-frounding-math" },
            extraArgs = {},
        },
    },
}
require("clangd_extensions").setup {
    server = {
        capabilities = capabilities,
        on_attach = on_attach,
        -- options to pass to nvim-lspconfig
        -- i.e. the arguments to require("lspconfig").clangd.setup({})
    },
    extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
            -- The highlight group priority for extmark
            priority = 100,
        },
        ast = {
            -- These are unicode, should be available in any font
            role_icons = {
                type = "🄣",
                declaration = "🄓",
                expression = "🄔",
                statement = ";",
                specifier = "🄢",
                ["template argument"] = "🆃",
            },
            kind_icons = {
                Compound = "🄲",
                Recovery = "🅁",
                TranslationUnit = "🅄",
                PackExpansion = "🄿",
                TemplateTypeParm = "🅃",
                TemplateTemplateParm = "🅃",
                TemplateParamObject = "🅃",
            },
            highlights = {
                detail = "Comment",
            },
        },
        memory_usage = {
            border = "none",
        },
        symbol_info = {
            border = "none",
        },
    },
}
lsp.cmake.setup { -- requires cmake-language-server (pkgs.cmake-language-server)
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        buildDirectory = "build",
    },
}
lsp.codeqlls.setup { -- requires codeql-cli (pkgs.codeql)
    capabilities = capabilities,
    on_attach = on_attach,
}
-- lsp.cssls.setup{ -- requires vscode-css-language-server (nodePackages.vscode-css-languageserver-bin or nodePackages.vscode-langservers-extracted)
--   -- Must install a snippet plugin and add `capabilities.textDocument.completion.completionItem.snippetSupport = true`
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.cssmodules_ls.setup{ -- requires cssmodules-language-server (not in nixpkgs, is an npm package)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.denols.setup{ -- requires deno (pkgs.deno)
--   -- and adding `vim.g.markdown_fenced_languages = { "ts=typescript" }` to config.
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.diagnosticls.setup { -- requires diagnostic-languageserver (nodePackages.diagnostic-languageserver)
    -- and configuration of whatever diagnostic tools it's used with.
    on_attach = on_attach,
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
    root_dir = lsp.util.root_pattern('.git'),
}
lsp.dockerls.setup { -- requires dockerfile-language-server-nodejs (nodePackages.dockerfile-language-server-nodejs)
    capabilities = capabilities,
    on_attach = on_attach,
}
-- lsp.dotls.setup{ -- requires dot-language-server (not in nixpkgs, is an npm package)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.efm.setup{ -- requires efm-langserver (pkgs.efm-langserver)
--   -- must also configure it for the commands it uses. See https://github.com/mattn/efm-langserver
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.eslint.setup { -- requires vscode-eslint-language-server (not available individually so needs nodePackages.vscode-langservers-extracted)
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx",
        "vue" },
    capabilities = capabilities,
    settings = {
        -- nodePath = "../.yarn/sdks"; -- only needed for yarn pnp
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
        packageManager = "pnpm",
        problems = {
            shortenToSingleLine = false,
        },
        quiet = true,
        run = "onType",
        validate = "on",
    },
    on_attach = on_attach,
}
-- lsp.gradle_ls.setup{ -- requires vscode-gradle gradle-language-server (neither available in nixpkgs)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.html.setup{ -- requires vscode-css-language-server (nodePackages.vscode-html-languageserver-bin or nodePackages.vscode-langservers-extracted)
--   -- Must install a snippet plugin and add `capabilities.textDocument.completion.completionItem.snippetSupport = true`
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.jedi_language_server.setup{ -- requires jedi-language-server (pythonPackages.jedi-language-server)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.jsonls.setup {
    -- Must install a snippet plugin and add `capabilities.textDocument.completion.completionItem.snippetSupport = true`
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        provideFormatter = true,
    },
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}
-- lsp.lean3ls.setup{ -- requires lean-language-server (not in nixpkgs, is an npm package)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.leanls.setup{ -- don't use this, instead use lean.nvim
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.ltex.setup { -- requires ltex-ls (pkgs.ltex-ls)
    capabilities = capabilities,
    on_attach = on_attach,
}
-- lsp.marksman.setup{ -- requires marksman (not in nixpkgs)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.mlir_lsp_server.setup{ -- requires mlir-lsp-server (not in nixpkgs, comes from llvm-project repo)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.neocmake.setup{ -- requires neocmakelsp (not in nixpkgs, is a cargo package)
--   -- still pretty experimental.
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.nil_ls.setup { -- requires nil (pkgs.nil)
    capabilities = capabilities,
    on_attach = on_attach,
}
-- lsp.omnisharp.setup{ (requires some weird config, but would be nice for C# stuff)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.opencl_ls.setup{ -- requires opencl-language server (not in nixpkgs, requires building)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
-- lsp.pylsp.setup{ -- requires python-lsp-server (pythonPackages.python-lsp-server)
--   capabilities = capabilities;
--   on_attach = on_attach;
--   settings = {
--     pylsp = {
--       configurationSources = {'flake8'};
--       plugins = {
--         autopep8 = {
--           enabled = false;
--         };
--         black = {
--           cache_config = true;
--           enabled = true;
--         };
--         flake8 = {
--           enabled = true;
--         };
--         formatter = { "black" };
--         jedi = {
--           environment = "./.venv";
--         };
--         jedi_completion = {
--           enabled = false;
--           include_params = true;
--           include_class_objects = true;
--           include_function_objects = true;
--           fuzzy = true;
--           eager = true;
--         };
--         mccabe = {
--           enabled = false;
--         };
--         pycodestyle = {
--           enabled = false;
--         };
--         pyflakes = {
--           enabled = false;
--         };
--         yapf = {
--           enabled = false;
--         };
--       };
--     };
--   };
-- }
-- lsp.pyre.setup{ -- requires pyre (not in nixpkgs)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.pyright.setup { -- requires pyright (nodePackages.pyright)
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
            },
        },
    },
}
lsp.rust_analyzer.setup { -- requires rust-analyzer (pkgs.rust-analyzer)
    capabilities = capabilities,
    on_attach = on_attach,
}
-- lsp.sqlls.setup{ -- requires sql-language-server (not in nixpkgs, is an npm package)
--   capabilities = capabilities;
--   on_attach = on_attach;
-- }
lsp.lua_ls.setup { -- requires lua-language-server (pkgs.lua-language-server)
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
lsp.taplo.setup { -- requires taplo-cli with lsp features enabled (pkgs.taplo)
    capabilities = capabilities,
    on_attach = on_attach,
}
lsp.texlab.setup { -- requires texlab (pkgs.texlab)
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 100,
            forwardSearch = {
                args = {},
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false,
            },
        },
    },
}
lsp.tsserver.setup { -- requires typescript-language-server (nodePackages.typescript-language-server)
    capabilities = capabilities,
    -- on_attach = on_attach,
    init_options = {
        hostInfo = "neovim",
    },
}
lsp.vimls.setup { -- requires vim-language-server (nodePackages.vim-language-server)
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        diagnostic = {
            enable = true,
        },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
            runtimepath = true,
        },
        isNeovim = true,
        iskeyword = "@,48-57,_,192-255,-#",
        runtimepath = "",
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true,
        },
        vimruntime = "",
    },
}
lsp.yamlls.setup { -- requires yaml-language-server (nodePackages.yaml-language-server)
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.5-standalone-strict/all.json"] = "/*.kube.yaml",
            },
        },
    },
}
lsp.zls.setup { -- requires zls (pkgs.zls)
    -- Zig language server
    capabilities = capabilities,
    on_attach = on_attach,
}

require "colorizer".setup {
    filetypes = { '*' },
    user_default_options = {
        RGB = false,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = false,
        mode = "virtualtext",
        tailwind = false,
        sass = { enable = false, parsers = {}, },
        virtualtext = "■",
    },
    buftypes = {},
}

-- require "todo-comments".setup {
--   -- your configuration comes here
--   -- or leave it empty to use the default settings
--   -- refer to the configuration section below
-- }

require "trouble".setup {}

vim.cmd([[
  au BufEnter * exe "normal! zR"
  " Don't have line numbers and fold columns for terminal buffers.
  au TermOpen * setlocal nonumber foldcolumn=0
  " Enable highlighting comments in json.
  au FileType json syntax match Comment +\/\/.\+$+
  " Treat header files as c++
  au BufRead,BufNewFile *.h set filetype=cpp
  " Return to last edit position (You want this!) *N*.
  au BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
  au FileReadPost * rundo /home/devon/.vim/undo
]])
-- au BufWritePre *.tsx,*.ts,*.jsx,*.js,*.cjs,*.mjs EslintFixAll

vim.g.mundo_right = 1                                           -- Open mundo tree view on the right.
vim.g.mundo_preview_bottom = 1                                  -- Show preview below window being changed.
vim.g.gitgutter_realtime = 1                                    -- Update in realtime
vim.g.gitgutter_async = 1                                       -- Update in background
vim.g.mergetool_layout = 'LmR'                                  -- Set layout for merging files.
vim.g.mergetool_prefer_revision = 'unmodified'                  -- Default to taking our side when merging.
vim.g.rooter_targets = '/,*'                                    -- directories and all files (default).
vim.g.rooter_cd_cmd = "lcd"                                     -- change directory for the current window only.
vim.g.rooter_change_directory_for_non_project_files = 'current' -- change dir to current if there is no project.
vim.g.rooter_silent_chdir = 1                                   -- Silently change directories.
vim.g.indentguides_conceal_color = "guifg=" .. vim.g.theme_selectionbg .. " guibg=NONE"

vim.cmd("g:rooter_patterns = ['Dockerfile', '.Jenkinsfile', '.git/', 'jsconfig.json']") -- Look for a dockerfile, jenkinsfile, or git dir to find root.

require 'tabline'.setup {
    enable = false,
    options = {
        section_separators = { '', '' },
        component_separators = { '', '' },
        max_bufferline_percent = nil, -- set to nil by default, and it uses vim.o.columns * 2/3
        show_tabs_always = true,
        show_devicons = true,         -- this shows devicons in buffer section
        show_bufnr = false,           -- this appends [bufnr] to buffer section,
        show_filename_only = false,   -- shows base filename only instead of relative path in filename
    }
}

vim.cmd [[
  set guioptions-=e " Use showtabline in gui vim
  set sessionoptions+=tabpages,globals " store tabpages and globals in session
]]

require("tidy").setup()

-- require("dapui").setup{}
-- require("nvim-dap-virtual-text").setup {
--   show_stop_reason = false,
-- }

require("lsp_lines").setup()
vim.diagnostic.config({
    virtual_lines = { only_current_line = true, },
    virtual_text = true,
})

require("treesitter-context").setup {
    enable = true,          -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0,          -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer',   -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    min_window_height = 16, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
}


require "nvim-treesitter.configs".setup {
    ensure_installed = {},
    sync_install = false,
    auto_install = false,
    ignore_install = { "ql_dbscheme" },
    autotag = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable = {},  -- optional, list of language that will be disabled
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = {
            vim.g.theme_darkfg,
            vim.g.theme_keyword,
            vim.g.theme_focus,
            vim.g.theme_constant,
            vim.g.theme_warm,
            vim.g.theme_type,
        },
        -- Which query to use for finding delimiters
        query = 'rainbow-parens',
        -- Highlight the entire buffer all at once
        strategy = require 'ts-rainbow'.strategy.global,
    },
}

require("lsp-colors").setup({})

require("compiler-explorer").setup()

require("Comment").setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'tcc',
        ---Block-comment toggle keymap
        block = 'tbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'tc',
        ---Block-comment keymap
        block = 'tbc',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
    },
    ---Function to call before (un)comment
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    ---Function to call after (un)comment
    post_hook = nil,
})

require('buffertag').setup({
    -- accepts any border options that `nvim_open_win` accepts.
    -- see ":help vim.api.nvim_open_win"
    border = "none",
    -- By default if the buffer name is too wide for the pane it's in, it will
    -- display and overlap the pane. By setting this to true, the buffer name will
    -- be truncated to fit within the pane, ensuring the floating window does not
    -- overlap any other panes.
    limit_width = false,
    -- if `vim.bo.modified` is `true` for the current buffer,
    -- display modified symbol before the buffer name.
    modified_symbol = "[●]", -- other modified symbol: "●"
})

vim.cmd([[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  set nofoldenable
]])
