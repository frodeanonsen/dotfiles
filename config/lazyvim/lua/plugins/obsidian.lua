return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note", mode = "n" },
    { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
    { "<leader>osw", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Follow link under cursor", mode = "n" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste imate from clipboard under cursor", mode = "n" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "follows note under cursor", mode = "n" },
    {
      "<leader>oe",
      "<cmd>ObsidianExtractNote<cr>",
      desc = "Extracts visually selected note creates a new one with link",
      mode = "n",
    },
    { "<leader>od", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Cycle through checkbox options.", mode = "n" },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    callbacks = {
      enter_note = function()
        vim.wo.conceallevel = 1
      end,
      leave_note = function()
        vim.wo.conceallevel = 0
      end,
    },

    workspaces = {
      {
        name = "Notes",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Example",
      },
      {
        name = "Zygizo",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Zygizo",
      },
    },

    -- see below for full list of options 👇
    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
      ["<leader>oo"] = {
        action = ":ObsidianOpen<CR>",
      },
      ["<leader>ob"] = {
        action = ":ObsidianBacklinks<CR>",
      },
      ["<leader>os"] = {
        action = ":ObsidianSearch<CR>",
      },
    },
  },
}
