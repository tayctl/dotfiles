-- lazygit.nvim is lazy-loaded by its commands (see plugins.lua)
-- vim.g.lazygit_floating_window_scaling_factor = 0.9

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGit current file' })
