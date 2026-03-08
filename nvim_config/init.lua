require("options")
require('commands')
require('misc')

local utils = require("utils")

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

local load_lazy = utils.set(load_lazy_non_nix, load_lazy_nix)

-- Actually execute the loading function we set above
load_lazy()

local lazyOptions = {
  performance = { rtp = { reset = utils.set(true, false) } },
  rocks = { enabled = true }
}

if utils.isNotNix then
  lazyOptions.lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
end

require("lazy").setup("plugins", lazyOptions)
