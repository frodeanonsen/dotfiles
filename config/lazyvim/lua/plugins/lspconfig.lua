return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        {
          -- Disable annoying error from `kotlin_language_server`.
          opts = { skip = true },
          filter = {
            event = "notify",
            find = "^kotlin_language_server: %-32603: Internal error%.$",
          },
        },
      },
    },
  },
}
