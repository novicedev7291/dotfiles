-- To reload buffer if file changes on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*.py" },
})

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
    log.fdebug("OS name is <>", os_name)
    local nix_rgx = vim.regex("[darwin|linux]")
    if os_name ~= nil and nix_rgx:match_str(os_name:lower()) ~= nil then
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

local load_formatter = function()
    local path = cache[M.defaults.name]
    if not path then
        local bin = find_bin_in_path(M.defaults.name)
        if bin == nil then
            log.debug("Formatter not available in path..doing nothing")
            return
        end
        log.ftrace("Formatter available at path <>", bin)
        cache[M.defaults.name] = bin
    end
end

--[[
Initialises the module with options.
@param: opts {
    name = "", --name of external formatter
    cmd_args = ""
 }
--]]
M.setup = function(opts)
    M.defaults = vim.tbl_extend("force", M.defaults, opts)
    load_formatter()
end

--[[
Format the given buffer number or file using configured external formatter.
Please make sure the formatter is available on `PATH` variable.

@param opts table of
     - buf: buffer number (integer)
     - file: filename (string) --not supported yet!
--]]
M.format = function(opts)
    local path = cache[M.defaults.name]
    if path == nil then
        log.error("Formatter not found on path, hence doing nothing")
        return
    end

    local args = { args = { vim.api.nvim_buf_get_name(opts.buf) } }
    if M.defaults.cmd_args ~= "" then
        args = { args = { M.defaults.cmd_args, vim.api.nvim_buf_get_name(opts.buf) } }
    end

    local handle, pid = vim.loop.spawn(path, args, function(code, _)
        if code ~= 0 then
            print("Formatter failed to convert, process exited with exit code", code)
        end
    end)
    log.ftrace("Process handle", handle, pid)
end

return M
