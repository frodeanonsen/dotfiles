return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    setup = function()
      vim.g.VM_leader = "m"
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"] = "",
      }
    end,
    keys = {
      { "<leader>m", desc = "Multiple Cursors" },
      { "<leader>mn", "<Plug>(VM-Find-Under)<CR>", desc = "Word under cursor" },
    },
  },
}
