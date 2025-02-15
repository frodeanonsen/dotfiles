return {
  {
    "cordx56/rustowl",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.rustowlsp.setup({})
    end,
  },
}
