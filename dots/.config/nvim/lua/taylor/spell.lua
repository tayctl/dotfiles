vim.opt.spellsuggest = 'best,9'

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typst', 'markdown', 'text', 'gitcommit' },
    callback = function(args)
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_gb'

        -- Insert mode: fix the previous misspelling with the first suggestion
        -- and carry on typing where you were.
        vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u',
            { buffer = args.buf, desc = 'Fix previous spelling error' })
    end,
})

-- z= opens a telescope picker of suggestions instead of the numbered menu
vim.keymap.set('n', 'z=', function()
    require('telescope.builtin').spell_suggest(
        require('telescope.themes').get_cursor({ prompt_title = 'Spelling' }))
end, { desc = 'Spelling suggestions' })
