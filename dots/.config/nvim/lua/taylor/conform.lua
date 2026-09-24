require('conform').setup({
    formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        typst = { 'typstyle' },
        java = { 'spotless' },
        nix = { 'nixfmt' },
        c = { "clang_format" },
    },
    formatters = {
        typstyle = {
            command = vim.fn.stdpath('data') .. '/mason/bin/typstyle',
            prepend_args = { '--wrap-text' },
        },
        prettier = {
            command = vim.fn.stdpath('data') .. '/mason/bin/prettier',
        },
        spotless = {
            command = 'gradle',
            args = {
                '--quiet',
                '--console=plain',
                'spotlessApply',
                '-PspotlessIdeHook=$FILENAME',
                '-PspotlessIdeHookUseStdIn',
                '-PspotlessIdeHookUseStdOut',
            },
            stdin = true,
        },
    },
})
