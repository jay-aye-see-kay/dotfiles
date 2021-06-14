M = {}

-- https://stackoverflow.com/a/7470789/7164888
function M.merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            M.merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

function M.nnoremap(from, to)
    vim.api.nvim_set_keymap('n', from, to, { noremap = true, silent=true })
end

function M.inoremap(from, to)
    vim.api.nvim_set_keymap('i', from, to, { noremap = true, silent=true })
end

function M.source(filename)
    vim.cmd('source' .. vim.fn.stdpath('config') .. '/' .. filename)
end

return M
