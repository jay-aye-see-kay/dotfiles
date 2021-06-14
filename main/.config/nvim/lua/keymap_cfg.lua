local whichkey = require('which-key')

whichkey.setup {
    plugins = {
        spelling = { enabled = true },
    },
    window = {
        border = "double",
    },
    layout = {
        align = "center",
        spacing = 6,
    },
}

vim.cmd('set timeoutlen=300')

local function direction_action_maps(direction)
    local direction_description = {
        left = 'left of buffer',
        right = 'right of buffer',
        above = 'above buffer',
        below = 'below buffer',
        leftmost = 'at left edge',
        rightmost = 'at right edge',
        top = 'at top edge',
        bottom = 'at bottom edge',
        in_place = 'in buffer',
        tab = 'in new tab',
    }

    local command_prefix = {
        left = 'aboveleft vsplit',
        right = 'belowright vsplit',
        above = 'aboveleft split',
        below = 'belowright split',
        leftmost = 'topleft vsplit',
        rightmost = 'botright vsplit',
        top = 'topleft split',
        bottom = 'botright split',
        in_place = '',
        tab = 'tabnew',
    }

    return {
        name = '+action '..direction_description[direction],
        t = {'<Cmd>'..command_prefix[direction]..' | terminal<CR>', 'builtin terminal'},
        g = {'<Cmd>'..command_prefix[direction]..' | Gedit :<CR>', 'git status'},
        p = {'<Cmd>'..command_prefix[direction]..' | Fern . -reveal=%<CR>', 'file tree (cwd)'},
        d = {'<Cmd>'..command_prefix[direction]..' | Fern %:h -reveal=%<CR>', 'file tree (of current file)'},
        l = {'<Cmd>Git log<CR><Cmd>q<CR><Cmd>'..command_prefix[direction]..' | Gedit -<CR>', 'git log'},
        -- TODO '.' should reopen the current buffer
    }
end


local main_keymap = {
    v = {
        name = '+neovim config',
        c = {'<cmd>edit $MYVIMRC<cr>', 'edit config file'},
        d = {'<cmd>edit '..vim.fn.stdpath('config')..'<cr>', 'open config directory'},
        r = {'<cmd>lua require("vimp").unmap_all()<cr><cmd>Reload<cr>', 'reload all config files'},
    },
    s = {'<cmd>HopWord<cr>', 'Hop [search] Word'},
    r = {
        name = '+lsp/refactoring',
        a = {'<cmd>Lspsaga code_action<cr>', 'code action'},
        r = {'<cmd>Lspsaga rename<cr>', 'rename symbol'},
        d = {'<cmd>Telescope lsp_document_diagnostics<cr>', 'show document diagnostics'},
        D = {'<cmd>Telescope lsp_workspace_diagnostics<cr>', 'show workspace diagnostics'},

        -- HACK: pop into insert mode after to trigger lsp applying settings
        q = {'<cmd>call v:lua.Quiet_lsp()<cr>i <bs><esc>', 'hide lsp diagnostics'},
        l = {'<cmd>call v:lua.Louden_lsp()<cr>i <bs><esc>', 'show lsp diagnostics'},
    },
    f = {
        name = '+find',
        b = {'<Cmd>Telescope buffers sort_lastused=true<CR>', '🔭 buffers'},
        f = {'<Cmd>Telescope find_files<CR>', '🔭 files'},
        g = {'<Cmd>Telescope git_files<CR>', '🔭 git files'},
        h = {'<Cmd>Telescope help_tags<CR>', '🔭 help tags'},
        c = {'<Cmd>Telescope commands<CR>', '🔭 commands'},
        q = {'<Cmd>Telescope quickfix<CR>', '🔭 quickfix'},
        o = {'<Cmd>Telescope oldfiles<CR>', '🔭 oldfiles'},
        l = {'<Cmd>Telescope current_buffer_fuzzy_find<CR>', '🔭 buffer lines'},
        w = {'<Cmd>Telescope spell_suggest<CR>', '🔭 spelling suggestions'},
        s = {'<Cmd>Telescope symbols<CR>', '🔭 unicode and emoji symbols'},
        a = {'<Cmd>Rg<CR>', 'FZF full text search'},
        p = {'<Cmd>lua require("telescope_z").list()<CR>', '🔭 jump to project with z'},
        n = {'<Cmd>lua require("telescope.builtin").grep_string({ cwd = "~/Documents/vimwiki" })<CR>', '🔭 personal notes'},
    },
    g = {
        name = '+git',
        g = {'<Cmd>Telescope git_commits<CR>', '🔭 commits'},
        c = {'<Cmd>Telescope git_bcommits<CR>', '🔭 buffer commits'},
        b = {'<Cmd>Telescope git_branches<CR>', '🔭 branches'},
        R = {'<Cmd>Gitsigns reset_hunk<CR>', 'reset hunk'},
        p = {'<Cmd>Gitsigns preview_hunk<CR>', 'preview hunk'},
        l = {'<Cmd>Gitsigns toggle_current_line_blame<CR>', 'toggle current line blame'},
    },
    h = direction_action_maps('left'),
    j = direction_action_maps('below'),
    k = direction_action_maps('above'),
    l = direction_action_maps('right'),
    H = direction_action_maps('leftmost'),
    J = direction_action_maps('bottom'),
    K = direction_action_maps('top'),
    L = direction_action_maps('rightmost'),
    ['.'] = direction_action_maps('in_place'),
    [','] = direction_action_maps('tab'),
}

whichkey.register(main_keymap, { prefix = '<leader>' })

whichkey.register({
    name = 'quick keymaps',
    b = main_keymap.f.b, -- buffers
    g = main_keymap.f.g, -- git_files
    f = main_keymap.f.f, -- find_files
    a = main_keymap.f.a, -- Rg
    ['.'] = main_keymap['.'].p, -- Fern .
}, { prefix = ',' })
