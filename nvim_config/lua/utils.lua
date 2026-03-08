local M = {}

M.isNix = vim.g.nix ~= nil
M.isNotNix = vim.g.nix == nil

function M.set(nonNix, nix)
    if M.isNix then
        return nix
    else
        return nonNix
    end
end

function M.is_loaded(name)
    local Config = require("lazy.core.config")
    return Config.plugins[name] and Config.plugins[name]._.loaded
end

return M
