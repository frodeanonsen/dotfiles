return {
  {
    "cordx56/rustowl",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.rustowl.setup({})

      vim.api.nvim_set_hl(0, "lifetime", { underline = true, sp = "#00ff00" })
      vim.api.nvim_set_hl(0, "imm_borrow", { underline = true, sp = "#0000ff" })
      vim.api.nvim_set_hl(0, "mut_borrow", { underline = true, sp = "#ff00ff" })
      vim.api.nvim_set_hl(0, "move", { underdouble = true, sp = "#ffff00" })
      vim.api.nvim_set_hl(0, "call", { underdouble = true, sp = "#ffff00" })
      vim.api.nvim_set_hl(0, "outlive", { underline = true, sp = "#ff0000" })
    end,
  },
}
