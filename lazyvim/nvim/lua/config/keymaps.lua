-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

map = vim.keymap.set

map("n", "<leader>dc", function()
  if vim.fn.filereadable(".vscode/launch.json") then
    require("dap.ext.vscode").load_launchjs(nil, { cpptools = { "c", "cpp" } })
  end
  require("dap").continue()
end, { desc = "Continue (launch.json)" })
