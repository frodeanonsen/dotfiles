return {
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("telescope").load_extension("harpoon")

      require("harpoon").setup({
        tabline = true,
        menu = {
          width = vim.api.nvim_win_get_width(0) - 20,
        },
      })
    end,

    keys = {
      { "<leader>h", desc = "Harpoon" },
      { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add file" },
      { "<leader>hr", "<cmd>lua require('harpoon.mark').rm_file()<cr>", desc = "Remove file" },
      { "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Quick menu" },
      { "<leader>ht", "<cmd>Telescope harpoon marks<cr>", desc = "Toggle harpoon" },
      { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Next harpoon" },
      { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Previous harpoon" },
      { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "File 1" },
      { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "File 2" },
      { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "File 3" },
      { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "File 4" },
    },
  },
}
