return {
  {
    'folke/which-key.nvim',
    config = function()
      local whichkey = require("which-key")

      -- document existing key chains
      whichkey.register {
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
      whichkey.register({
        ['<leader>'] = { name = 'VISUAL <leader>' },
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })

      -- Unclear why these aren't done through which-key
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

      whichkey.register({
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
    end,
  },
}
