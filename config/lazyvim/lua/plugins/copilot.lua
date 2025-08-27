return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup()

      -- Auto-attach copilot to buffers
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
            vim.schedule(function()
              require("copilot.client").buf_attach()
            end)
          end
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      completion = {
        menu = {
          auto_show = false,
        },
      },

      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_and_accept" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-Space>"] = { "show" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
