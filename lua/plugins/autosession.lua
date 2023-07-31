return {
    'rmagatti/auto-session',
    config = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        require('auto-session').setup {
            --do we try load session if none in cwd? (no)
            auto_session_enable_last_session = false,
            auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions/',
            auto_session_enabled = true,
            auto_save_enabled = true,
            auto_restore_enabled = true,
            auto_session_suppress_dirs = nil,
        }
    end,
}
