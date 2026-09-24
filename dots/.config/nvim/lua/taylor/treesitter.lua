-- Install parsers (replaces ensure_installed)
require('nvim-treesitter').install()

-- Enable treesitter highlighting for all filetypes (except latex)
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local ft = args.match
        if ft == 'tex' or ft == 'latex' then
            return
        end
        pcall(vim.treesitter.start)
    end,
})

-- Textobjects (new API)
require('nvim-treesitter-textobjects').setup {
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
}

-- Select: af/if for functions
vim.keymap.set({ 'x', 'o' }, 'af', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end)

-- Move: ]f/[f to jump between functions
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end)


-- select inner parts (if then else blocks)
vim.keymap.set({ 'x', 'o' }, 'ai', function()
   require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ii', function()
   require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects')
end)
