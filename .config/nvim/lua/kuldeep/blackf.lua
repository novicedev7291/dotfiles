local log = require("consolelog").setup { name = "Black_Formatter" }

local path_in_dir = function(dir_path, name)
    local paths = vim.fs.find(name, { path = dir_path, limit = 1, type = 'file' })
    if #paths ~= 0 then
        return paths[1]
    end
    return nil
end

local find_bin_in_path = function(name)
    local paths
    local os_name = vim.loop.os_uname().sysname
    if os_name ~= nil and string.match(os_name, "[Dd]arwin") ~= nil then
        -- PATH separater will be `:`
        paths = vim.split(vim.env.PATH, ":", { trimempty = true })
        for _, path in pairs(paths) do
            local abs_path = path_in_dir(path, name)
            if abs_path ~= nil then
                return abs_path
            end
        end
    end
    return nil
end

local cache = {}
local M = {
}

M.defaults = {
    name = "",
    cmd_args = ""
}

---Initialises the module with options.
---`@param: opts {
---    name = "", --name of external formatter
---    cmd_args = ""
--- }`
M.setup = function(opts)
    M.defaults = vim.tbl_extend("force", M.defaults, opts)
    local path = cache[M.defaults.name]
    if not path then
        local bin = find_bin_in_path(M.defaults.name)
        log.debug("Binary found at path <>", bin)
        if bin == nil then
            log.error("Formatter not available in path..doing nothing")
            return
        end
        cache[M.defaults.name] = bin
        path = cache[M.defaults.name]
    end
end

---Format the given buffer number or file using configured external formatter.
---Please make sure the formatter is available on `PATH` variable.
---
---`@param opts table of
---     - buf: buffer number (integer)
---     - file: filename (string)`
M.format = function(opts)
    local path = cache[M.defaults.name]
    if path == nil then
        log.error("Formatter not found on path, hence doing nothing")
        return
    end

    local handle, pid = vim.loop.spawn(path, { args = { vim.api.nvim_buf_get_name(opts.buf) } }, function(code, _)
        log.trace("Exit status", code)
    end)
    log.trace("Process handle", handle, pid)
end

return M
