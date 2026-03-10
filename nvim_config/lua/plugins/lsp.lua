-- LSP Configuration & Plugins
local utils = require("utils")

local update_border = function()
    local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
    local orig_floating_preview = vim.lsp.util.open_floating_preview

    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_floating_preview(contents, syntax, opts, ...)
    end
end

local on_attach = function(client, bufnr)
  update_border()

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Supports
  local supp = function(method)
    return client.supports_method(method)
  end

  -- Conditional normal map
  local cnmap = function(method, keys, func, desc)
    if supp(method) then
      nmap(keys, func, desc)
    end
  end

  cnmap("textDocument/hover", "<C-h>", vim.lsp.buf.hover, "Hover Docs")
  cnmap("textDocument/definition", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  cnmap("textDocument/declaration", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  cnmap("textDocument/implementation", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  cnmap("textDocument/typeDefinition", "<leader>de", vim.lsp.buf.type_definition, "[T]ype [D]efinition")
  cnmap("textDocument/rename", "<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
  cnmap("textDocument/codeAction", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>TD', require('telescope.builtin').lsp_type_definitions, '[T]ype [D]efinitions')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  if supp("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true)
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        enabled = utils.isNotNix,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        enabled = utils.isNotNix,
      },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/neodev.nvim',
      },
    },
    config = function()
      if utils.isNotNix then
        -- mason-lspconfig requires that these setup functions are called in this order
        -- before setting up the servers.
        require('mason').setup()
        require('mason-lspconfig').setup()
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      vim.lsp.config('*', {
        on_attach = on_attach,
        capabilities = capabilities
      })

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library',
                -- '${3rd}/busted/library',
              },
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          -- Unset 'formatexpr'
          -- vim.bo[args.buf].formatexpr = nil
          -- Unset 'omnifunc'
          vim.bo[args.buf].omnifunc = nil
          -- Unmap K
          vim.keymap.del('n', 'K', { buffer = args.buf })
          vim.keymap.set('n', 'K', '5<Plug>(SmoothieUpwards)', { desc = "Scroll smoothly upwards 5 lines.", noremap = false })
          -- Disable document colors
          -- vim.lsp.document_color.enable(false, args.buf)
        end,
      })

      vim.lsp.enable("bashls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("cmake")
      vim.lsp.enable('docker_compose_language_service')
      vim.lsp.enable("docker_language_server")
      vim.lsp.enable("futhark_lsp")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("marksman")
      vim.lsp.enable("nixd")
      vim.lsp.enable("pyright")
      vim.lsp.enable("systemd_lsp")
      vim.lsp.enable("ts_ls")
    end,
  },
}
