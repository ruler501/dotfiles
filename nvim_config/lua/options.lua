-- See `:help vim.o`
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
