local function expand(arg)
  result = {}
  queue = { arg }

  item = table.remove(queue)
  while item do
    local children = item["children"]
    if children then
      for i, v in ipairs(children) do
        v["prefix"] = (item["prefix"] or "") .. (v["prefix"] or "")
        table.insert(queue, v)
      end

      local name = item["name"]

      if name then
        table.insert(result, { item["prefix"], group = name })
      end
    else
      item[1] = (item["prefix"] or "") .. item[1]
      item["prefix"] = nil
      table.insert(result, item)
    end

    item = table.remove(queue)
  end

  return result
end

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

return {
  {
    'folke/which-key.nvim',

    dependencies = {
      "nvim-mini/mini.icons",
    },

    event = "VeryLazy",

    opts = {
      preset = "helix",

      spec = expand({children = {
        {
          prefix = '<Leader>',
          children = {
            {
              prefix ='i',
              children = {
                {'a', '<Cmd>TSLspImportAll<CR>', desc = "Add any missing imports.", mode = 'n' },
                {'o', '<Cmd>TSLspOrganize<CR>', desc = "Sort existing imports.", mode = 'n' },
              },
            },
            {
              prefix = 'f',
              children = {
                {'r', '<Cmd>TSLspRenameFile<CR>', desc = "Do a refactor renaming the current file.", mode = 'n' },
              },
            },
          },
        },
        -- [')'] = { '^', ".", mode = 'nx' },
        {
          prefix ='c',
          children = {
            -- ['f'] = { vim.lsp.buf.formatting, "Format the current buffer.", mode = 'n' },
            {'r', vim.lsp.buf.rename, desc = "Rename all references to the currently selected symbol.", mode = 'n' },
          -- ['n'] = {
          --     ['s'] = { possession.new, "Create a new session.", mode = "n" },
          -- },
          },
        },
        {
          prefix = "g",
          name = "Go To",
          children = {
            -- { '(', 'g^', mode = 'nx' },
            {'b', '<C-O>', desc = "[g]o [b]ackwards in the jump list.", mode = 'n' },
            {'d', vim.lsp.buf.definition, desc = "[g]o to the [d]efinition of the symbol under the cursor.", mode = 'n' },
            {'D', vim.lsp.buf.declaration, desc = "[g]o to the [D]eclaration of the symbol under the cursor.", mode = 'n' },
            {'e', vim.diagnostic.goto_next, desc = "[g]o to the next [e]rror.", mode = 'n' },
            {'E', vim.diagnostic.goto_prev, desc = "[g]o to the previous [E]rror.", mode = 'n' },
            {'f', '<C-I>', desc = "[g]o [f]orwards in the jump list.", mode = 'n' },
            {'i', vim.lsp.buf.implementation, desc = "[g]o to the [i]mplementation of the symbol under the cursor.", mode = 'n' },
            {
              prefix = 'q',
              -- name = "Quickfix",
              children = {
                {'N', '<Cmd>cprev<CR>', desc = "Go to the previous error in the quickfix list.", mode = 'n' },
                {'n', '<Cmd>cnext<CR>', desc = "Go to the next error in the quickfix list.", mode = 'n' },
              },
            },
            {
              prefix = 't',
              -- name = "Type",
              children = {
                {'d', vim.lsp.buf.type_definition, desc = "[g]o to the [t]ype [d]efinition of the symbol under the cursor.", mode = 'n' },
              },
            },
          },
        },
        {'h', '<BS>', desc = 'Move one column to the left with line wrapping.', mode = 'n' },
        {'H', '5zh5h', desc = "Scroll 5 columns to the left without moving the cursor relative to the screen.", mode = 'n' },
        {'<C-H>', vim.lsp.buf.hover, desc = "Show hover information.", mode = 'n' },
        {'J', '5<Plug>(SmoothieDownwards)', desc = "Scroll smoothly downwards 5 lines.", mode = 'n', noremap = false },
        {'K', '5<Plug>(SmoothieUpwards)', desc = "Scroll smoothly upwards 5 lines.", mode = 'n', noremap = false },
        {'L', '5zl5l', desc = "Scroll 5 columns right without moving the cursor relative to the screen.", mode = 'n' },
        {'l', '<Space>', desc = 'Move one character to the right with line wrapping.', mode = 'n' },
        {
          prefix = 'm',
          children = {
            {
              prefix ='s',
              children = {
                {'e', '<C-W>=', desc = "Make all splits the same size.", mode = 'n' },
                {'h', '<Cmd>split<CR>', desc = "Make a new horizontal split.", mode = 'n' },
                {'v', '<Cmd>vsplit<CR>', desc = "Make a new vertical split.", mode = 'n' },
              },
            },
          },
        },
        {'<C-N>', '<Cmd>enew<CR>', desc = "Open a blank new buffer.", mode = 'n' },
        -- {'p', '"_dP', desc = "Paste from the system clipboard.", mode = 'x' },
        {'q', '<Nop>', mode = 'n' },
        {
          prefix = '<C-R>',
          children = {
            {
              'h',
              '<Cmd>call animate#window_delta_height(5)<CR>',
              desc = "Smoothly increase the current windows height by 5 rows.",
              mode = 'n'
            },
            {
              'H',
              '<Cmd>call animate#window_delta_height(-5)<CR>',
              desc = "Smoothly decrease the current windows height by 5 rows.",
              mode = 'n'
            },
            {
              'w',
              '<Cmd>call animate#window_delta_width(5)<CR>',
              desc = "Smoothly increase the current windows width by 5 columns.",
              mode = 'n'
            },
            {
              'W',
              '<Cmd>call animate#window_delta_width(-5)<CR>',
              desc = "Smoothly decrease the current windows height by 5 columns.",
              mode = 'n'
            },
          },
        },
        {
          prefix = 's',
          children = {
            { 'b', "<Cmd>Neotree buffers<CR>", desc = "Show the Neotree buffer explorer.", mode = "n" },
            {
              prefix = 'c',
              children = {
                { 'a', vim.lsp.buf.code_action, desc = "Show available code actions at this position.", mode = 'n' },
              }
            },
            { 'e', vim.diagnostic.open_float, desc = "Show diagnostics in a new float.", mode = 'n' },
            { 'f', "<Cmd>Neotree filesystem<CR>", desc = "Show the Neotree file explorer.", mode = "n" },
            {
              prefix ='h',
              children = {
                { 'g', '<Cmd>call SynStack()<CR>', desc = "Show the highlight group stack at the current position.", mode = 'n' },
              },
            },
            {'j', '<Cmd>jumps<CR>', desc = "Show the jump list.", mode = 'n' },
            {'m', '<Cmd>marks<CR>', desc = "Show all marks.", mode = 'n' },
            {
              'r',
              '<Cmd>TroubleToggle lsp_references<CR>',
              desc = "Toggle showing all references to the symbol under the cursor.",
              mode = 'n'
            },
          },
        },
        {
          prefix = 't',
          children = {
            {
              prefix = 'd',
              children = {
                {
                  'd',
                  '<Cmd>TroubleToggle document_diagnostics<CR>',
                  desc = "Toggle showing a window with the diagnostics for the current document.",
                  mode = 'n',
                },
                {
                  'w',
                  '<Cmd>TroubleToggle workspace_diagnostics<CR>',
                  desc = "Toggle showing a window with all the diagnostics for the current workspace.",
                  mode = 'n'
                },
              },
            },
            {
              prefix = 'l',
              children = {
                {'l', '<Cmd>TroubleToggle loclist<CR>', desc = "Toggle showing a window with the location list.", mode = 'n' },
              },
            },
            {
              prefix = 'm',
              children = {
                {'p', '<Plug>MarkdownPreviewToggle', desc = 'Toggle a live markdown live preview in the browser.', mode = 'n' },
              },
            },
            {
              'q',
              '<Cmd>TroubleToggle quickfix<CR>',
              desc = "Toggle showing a window with the current quickfix list.",
              mode = 'n'
            },
            {
              'r',
              '<Cmd>TroubleToggle lsp_references<CR>',
              desc = "Toggle showing all references to the symbol under the cursor.",
              mode = 'n'
            },
            {
              's',
              '<Cmd>SymbolsOutline<CR>',
              desc = 'Toggle showing a tree based outline of all symbols in the current buffer.',
              mode = 'n'
            },
            {'t', '<Cmd>TroubleToggle<CR>', desc = "Toggle showing the trouble(list) window.", mode = 'n' },
            {
              prefix = 'u',
              children = {
                {'h', '<Cmd>MundoToggle<CR>', desc = "Toggle showing the undo history tree.", mode = 'n' },
              },
            },
          },
        },
        {'U', '<C-R>', desc = "Redo the last action.", mode = 'n' },
        {'x', '"_x', desc = "Delete the character under the cursor.", mode = 'n' },
      }}),
    },

    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },

    -- config = function()
    --   local wk = require("which-key")

      -- document existing key chains
      -- wk.register {
      --   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      --   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      --   ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      --   ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      --   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      --   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      --   ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
      --   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      -- }

      -- register which-key VISUAL mode
      -- required for visual <leader>hs (hunk stage) to work
      -- wk.register({
      --   ['<leader>'] = { name = 'VISUAL <leader>' },
      --   ['<leader>h'] = { 'Git [H]unk' },
      -- }, { mode = 'v' })
    -- end,
  },
}
