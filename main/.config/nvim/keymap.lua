local whichkey = require('which-key')
local helpers = require('helpers')

vim.cmd('set timeoutlen=300')

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

local function make_directed_maps(command_desc, command)
    local directions = {
        left =      { key = 'h' , description = 'to left'        , command_prefix = 'aboveleft vsplit' }  ,
        right =     { key = 'l' , description = 'to right'       , command_prefix = 'belowright vsplit' } ,
        above =     { key = 'k' , description = 'above'          , command_prefix = 'aboveleft split' }   ,
        below =     { key = 'j' , description = 'below'          , command_prefix = 'belowright split' }  ,
        in_place =  { key = '.' , description = 'in place'       , command_prefix = nil }                  ,
        tab =       { key = ',' , description = 'in new tab'     , command_prefix = 'tabnew' }            ,
        -- leftmost =  { key = 'H' , description = 'to left edge'   , command_prefix = 'topleft vsplit' }    ,
        -- rightmost = { key = 'L' , description = 'to right edge'  , command_prefix = 'botright vsplit' }   ,
        -- top =       { key = 'K' , description = 'to top edge'    , command_prefix = 'topleft split' }     ,
        -- bottom =    { key = 'J' , description = 'to bottom edge' , command_prefix = 'botright split' }    ,
    }

    local maps = {}
    for _, d in pairs(directions) do
        local full_description = command_desc .. ' ' .. d.description
        local full_command = d.command_prefix -- approximating a ternary
            and '<CMD>' .. d.command_prefix .. ' | ' .. command .. '<CR>'
            or '<CMD>' .. command .. '<CR>'

        maps[d.key] = { full_command, full_description  }
    end
    return maps
end

local directed = {
    git_status = make_directed_maps('Git Status', 'Gedit :'),
    new_terminal = make_directed_maps('New terminal', 'terminal'),
    file_explorer = make_directed_maps('File explorer', 'Fern . -reveal=%'),
    roaming_file_explorer = make_directed_maps('File explorer (focused on file\'s directory)', 'Fern %:h -reveal=%'),
    todays_notepad = make_directed_maps('Today\'s notepad', 'VimwikiMakeDiaryNote'),
    yesterdays_notepad = make_directed_maps('Yesterday\'s notepad', 'VimwikiMakeYesterdayDiaryNote'),
    tomorrows_notepad = make_directed_maps('Tomorrow\'s notepad', 'VimwikiMakeTomorrowDiaryNote'),
}

local main_keymap = {
    v = {
        name = '+neovim config',
        c = {'<cmd>edit $MYVIMRC<cr>', 'edit config file'},
        d = {'<cmd>edit '..vim.fn.stdpath('config')..'<cr>', 'open config directory'},
        r = {'<cmd>Reload<cr>', 'reload all config files'},
    },
    l = {
        name = '+lsp',
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
        b = {'<Cmd>Buffers<CR>', '🔭 buffers'},
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
    g = helpers.merge(directed.git_status, {
        name = '+git',
        g = {'<Cmd>Telescope git_commits<CR>', '🔭 commits'},
        c = {'<Cmd>Telescope git_bcommits<CR>', '🔭 buffer commits'},
        b = {'<Cmd>Telescope git_branches<CR>', '🔭 branches'},
        R = {'<Cmd>Gitsigns reset_hunk<CR>', 'reset hunk'},
        p = {'<Cmd>Gitsigns preview_hunk<CR>', 'preview hunk'},
    }),
    t = helpers.merge(directed.new_terminal, {
        name = '+terminal',
    }),
    e = helpers.merge(directed.file_explorer, {
        name = '+file explorer',
        ['e'] = helpers.merge(directed.roaming_file_explorer, {
            name = '+in current file\' directory',
        }),
    }),
    n = helpers.merge(directed.todays_notepad, {
        name = '+notes',
        f = {'<Cmd>lua require("telescope.builtin").grep_string({ cwd = "~/Documents/vimwiki" })<CR>', '🔭 search all notes'},
        y = helpers.merge(directed.yesterdays_notepad, {
            name = '+Yesterday\' notepad',
        }),
        t = helpers.merge(directed.tomorrows_notepad, {
            name = '+Tomorrow\' notepad',
        }),
    }),
}

whichkey.register(main_keymap, { prefix = '<leader>' })

whichkey.register({
    name = 'quick keymaps',
    b = main_keymap.f.b, -- buffers
    g = main_keymap.f.g, -- git_files
    f = main_keymap.f.f, -- find_files
    o = main_keymap.f.o, -- old_files
    a = main_keymap.f.a, -- Rg
    ['.'] = main_keymap.e['.'], -- Fern .
    ['>'] = main_keymap.e.e['.'], -- Fern . (relative to file)
    s = {'<Cmd>:wa<CR>', 'save all'},
}, { prefix = ',' })
