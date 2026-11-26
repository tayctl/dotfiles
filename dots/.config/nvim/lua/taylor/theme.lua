-- Follows the system theme written by scripts/theme.sh
local M = {}

local state = vim.fn.expand("~/.local/state/theme/nvim")

function M.apply()
  local name = "gruvbox"
  local f = io.open(state, "r")
  if f then
    name = vim.trim(f:read("*a"))
    f:close()
  end
  if name == "" or name == vim.g.colors_name then return end
  vim.o.background = "dark"
  pcall(vim.cmd.colorscheme, name)
end

-- Transparent background so the terminal shows through, for any colorscheme
local transparent_groups = {
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn",
  "EndOfBuffer", "FoldColumn", "LineNr", "CursorLineNr", "MsgArea",
}

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, group in ipairs(transparent_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      hl.bg = nil
      hl.ctermbg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
})

M.apply()

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  callback = M.apply,
})

return M
