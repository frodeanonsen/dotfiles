lvim.plugins = {
  { "christoomey/vim-tmux-navigator" },
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'BufEnter',
  --   config = function()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
  --     vim.keymap.set('i', '<c-l>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
  --     vim.keymap.set('i', '<c-h>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
  --     vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  --   end
  -- },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          -- suggestion = { enabled = false },
          -- panel = { enabled = false },
        })                             -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },
  {
    -- Use treesitter to autoclose and autorename html tag
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    config = function()
      vim.cmd([[
                let g:VM_maps = {}
                let g:VM_mouse_mappings = 1
                ]])
    end,
  },
  { "tpope/vim-surround" },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          -- require('hover.providers.man')
          -- require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = nil
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true
      }

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      lvim.builtin.which_key.mappings["t"] = {
        name = "Trouble",
        r = { "<cmd>Trouble lsp_references<cr>", "References" },
        f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
        q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
        l = { "<cmd>Trouble loclist<cr>", "LocationList" },
        t = { "<cmd>TodoTrouble<cr>", "Todos" },
      }
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { 'nvim-telescope/telescope.nvim', 'ibhagwan/fzf-lua' },
    config = function()
      require('neoclip').setup()

      lvim.builtin.which_key.mappings["y"] = { "<cmd>Telescope neoclip<cr>", "Clips" }
    end,
  },
  {
    'pwntester/octo.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require "octo".setup()

      lvim.builtin.which_key.mappings["gh"] = {
        name = "GitHub",
        i = {
          name = "Issues",
          l = { "<cmd>Octo issue list<cr>", "List" },
          c = { "<cmd>Octo issue close<cr>", "Close" },
          n = { "<cmd>Octo issue create<cr>", "New" },
          f = { "<cmd>Octo issue search<cr>", "Find" },
          b = { "<cmd>Octo issue browser<cr>", "Open in browser" },
          y = { "<cmd>Octo issue url<cr>", "Yank url" },
        },
        p = {
          name = "Pull Requests",
          l = { "<cmd>Octo pr list<cr>", "List" },
          c = { "<cmd>Octo pr close<cr>", "Close" },
          n = { "<cmd>Octo pr create<cr>", "New" },
          f = { "<cmd>Octo pr search<cr>", "Find" },
          b = { "<cmd>Octo pr browser<cr>", "Open in browser" },
          y = { "<cmd>Octo pr url<cr>", "Yank url" },
          s = { "<cmd>Octo pr checks<cr>", "Checks status" },
        },
        r = {
          name = "Repo",
          l = { "<cmd>Octo repo list<cr>", "List" },
          b = { "<cmd>Octo repo browser<cr>", "Open in browser" },
          y = { "<cmd>Octo repo url<cr>", "Yank url" },
          o = { "<cmd>Octo repo view<cr>", "Open repo" },
        },
      }
    end
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        tmux = { enabled = false },
      }
    }
  },
  -- Quick search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
  },
  -- Quick jumping between files
  {
    'ThePrimeagen/harpoon',
    config = function()
      require("telescope").load_extension('harpoon')

      require("harpoon").setup({
        tabline = true,
        menu = {
          width = vim.api.nvim_win_get_width(0) - 20,
        }
      })

      -- keybindings:
      -- 1 - add file
      -- 2 - add file to harpoon
      -- 3 - remove file from harpoon
      -- 4 - toggle harpoon
      -- 5 - jump to next harpoon
      -- 6 - jump to previous harpoon
      lvim.builtin.which_key.mappings["h"] = {
        name = "Harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add file" },
        r = { "<cmd>lua require('harpoon.mark').rm_file()<cr>", "Remove file" },
        h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Quick menu" },
        t = { "<cmd>Telescope harpoon marks<cr>", "Toggle harpoon" },
        n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next harpoon" },
        p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Previous harpoon" },
      }
      lvim.builtin.which_key.mappings["h1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "File 1" }
      lvim.builtin.which_key.mappings["h2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "File 2" }
      lvim.builtin.which_key.mappings["h3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "File 3" }
      lvim.builtin.which_key.mappings["h4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "File 4" }
    end,

    -- keys = {
    --   {
    --     "<a-1>",
    --     mode = { "n" },
    --     function() require("harpoon.ui").nav_file(1) end,
    --     desc =
    --     "Harpoon file 1"
    --   },
    -- }
  },
  -- testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")(),
        }
      })
      lvim.builtin.which_key.mappings["v"] = {
        name = "Verify",
        t = { "<cmd>lua require('neotest').run.run()<cr>", "Test" },
      }
    end
  },
  "rcasia/neotest-java",
  -- Themes
  {
    'projekt0n/github-nvim-theme',
    priority = 1000,
    config = function()
      require('github-theme').setup({
        -- ...
      })

      lvim.colorscheme = "github_dark"
      lvim.transparent_window = true
    end,
  },
  { "catppuccin/nvim",             name = "catppuccin" },

  -- Database
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    event = "VeryLazy",
  },
  {
    "ellisonleao/dotenv.nvim",
  },
  -- Telescope extensions
  { "jvgrootveld/telescope-zoxide" },

}
