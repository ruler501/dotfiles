-- Add indentation guides even on blank lines
return {
  {
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
      {
        'rktjmp/lush.nvim',
        lazy = false,
        config = function()
          require('lush')(require('lush_theme/darkviolet'));
        end,
      },
    },
  },
}
