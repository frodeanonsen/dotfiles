return {
  {
    "saghen/blink.cmp",

    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_and_accept" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
    },
  },
}
