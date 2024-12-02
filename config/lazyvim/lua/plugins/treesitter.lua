return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add just
      vim.list_extend(opts.ensure_installed, {
        "just",
      })
    end,
  },
}
