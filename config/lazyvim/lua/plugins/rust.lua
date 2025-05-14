-- return {
--   "cordx56/rustowl",
--   dependencies = { "neovim/nvim-lspconfig" },
--   config = function()
--     local lspconfig = require("lspconfig")
--     lspconfig.rustowl.setup({})
--
--     vim.api.nvim_set_hl(0, "lifetime", { underline = true, sp = "#00ff00" })
--     vim.api.nvim_set_hl(0, "imm_borrow", { underline = true, sp = "#0000ff" })
--     vim.api.nvim_set_hl(0, "mut_borrow", { underline = true, sp = "#ff00ff" })
--     vim.api.nvim_set_hl(0, "move", { underdouble = true, sp = "#ffff00" })
--     vim.api.nvim_set_hl(0, "call", { underdouble = true, sp = "#ffff00" })
--     vim.api.nvim_set_hl(0, "outlive", { underline = true, sp = "#ff0000" })
--   end,
-- }

return {
  "cordx56/rustowl",
  version = "*", -- Latest stable version
  build = "cd rustowl && cargo install --path . --locked",
  lazy = false, -- This plugin is already lazy
  opts = {
    client = {
      on_attach = function(_, buffer)
        vim.keymap.set("n", "<leader>co", function()
          require("rustowl").toggle(buffer)
        end, { buffer = buffer, desc = "Toggle RustOwl" })
      end,
    },
  },
}
