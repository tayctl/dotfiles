-- Formatters come from PATH (nix / project devenvs). Ones that aren't
-- installed are skipped; if none is, the LSP formats instead (lsp.lua).
-- stop_after_first: use the first one of the list that is installed.
require('conform').setup({
    notify_no_formatters = false,
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
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        python = { 'ruff_format', 'black', stop_after_first = true },
        lua = { 'stylua' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        rust = { 'rustfmt' },
        go = { 'gofmt' },
        toml = { 'taplo' },
        cmake = { 'cmake_format' },
    },
    formatters = {
        typstyle = {
            prepend_args = { '--wrap-text' },
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
