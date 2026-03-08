-- Fuzzy Finder (files, lsp, etc)
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    cmd = "Telescope",
    config = function()
      vim.defer_fn(function()
        local telescope = require('telescope')
        -- See `:help telescope` and `:help telescope.setup()`
        telescope.setup {
          defaults = {
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
              },
            },
          },
        }
      end, 0)
    end,
  },
}
